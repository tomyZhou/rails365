class User < ActiveRecord::Base
  ALLOW_LOGIN_CHARS_REGEXP = /\A[A-Za-z0-9\-\_\.]+\z/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async, authentication_keys: [:login]
  devise :omniauthable, omniauth_providers: [:github]

  act_as_liker
  has_many :like_movies, through: "likees", source: :likee, source_type: "Movie"
  has_many :like_original_movies, -> { Movie.original }, through: "likees", source: :likee, source_type: "Movie"
  has_many :like_articles, through: "likees", source: :likee, source_type: "Article"
  has_many :like_softs, through: "likees", source: :likee, source_type: "Soft"

  has_many :articles
  has_many :orders

  has_many :comments, as: 'commentable'

  validate :validate_username
  validates :username, format: { with: ALLOW_LOGIN_CHARS_REGEXP, message: '只允许数字、大小写字母和下划线' },
                       length: { in: 3..20 }, presence: true,
                       uniqueness: { case_sensitive: true }

  mount_uploader :avatar, AvatarUploader

  def self.from_omniauth(auth)
    ap auth.extra.raw_info.login
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = "from_github_#{auth.info.email}"
      user.username = auth.extra.raw_info.login
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def letter_avatar_url(size)
    avatar_url || LetterAvatar.generate(Pinyin.t(self.username), size).sub('public/', '/')
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def self.serialize_from_session(key, salt)
    Rails.cache.fetch "current_user_#{key}" do
      super
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_hash).first
    end
  end

  def self.bg_save_movie_history
    # 首页 Top 5 活跃学员
    Rails.cache.delete "active_weight_users"
    # Top 100 活跃学员
    Rails.cache.delete 'active_users'

    self.find_each do |user|
      ids = $redis.lrange("movies_#{user.id}_history", 0, -1).uniq
      if ids.present?
        puts "user #{user.id}"
        user.movie_history = ids
        user.save
      elsif user.movie_history.present?
        $redis.lpush "movies_#{user.id}_history", user.movie_history
        $redis.ltrim "movies_#{user.id}_history", 0, 99
      end
      user.active_weight = user.movie_history.size.to_i rescue 0 + user.like_original_movies.count.to_i + user.comments.count.to_i
      user.save
    end

    Redis.new.publish 'ws', { only_website: true, title: '祝贺', content: "目前 Top 5 活跃会员分别是 #{User.order(active_weight: :desc, id: :desc).limit(5).map(&:hello_name).map{ |name| "<strong>#{name}</strong>" }.join(', ')}" }.to_json
  end

  def self.random_like
    self.find_each do |user|
      articles = Article.limit(rand(Article.count))
      articles.each do |article|
        user.like article
        article.update_like_count
      end

      movies = Movie.limit(rand(Movie.count))
      movies.each do |movie|
        user.like movie
        movie.update_like_count
      end

      softs = Soft.limit(rand(Soft.count))
      softs.each do |soft|
        user.like soft
        soft.update_like_count
      end
    end
  end

  def hello_name
    self.nickname || self.username
  end

  def order_name
    "#{self.id} - #{self.hello_name}"
  end

  def signature_name
    self.company_name.present? ? "#{self.position} @ #{self.company_name}" : self.position
  end

  def self.set_paid(user_id, number, money)
    user = self.find(user_id)
    Rails.cache.delete "current_user_[#{user.id}]"
    user.is_paid = true

    if user.pay_expired_at && user.pay_expired_at > Time.now
      user.pay_expired_at = user.pay_expired_at + number.months
    else
      user.pay_expired_at = Time.now + number.months
    end

    user.save!

    order = user.orders.new(expired_at: user.pay_expired_at, month: number, money: money)
    order.save!
  end

  def self.set_expired_time
    self.where(is_paid: true).where.not(pay_expired_at: nil).each do |user|
      if Time.now > user.pay_expired_at
        user.is_paid = false
        user.save(validate: false)
        Rails.cache.delete "current_user_[#{user.id}]"
      end
    end
  end

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def super_admin?
    Settings.admin_emails.include?(email)
  end

  after_commit :send_ws_message, on: :create

  private

  def send_ws_message
    Redis.new.publish 'ws', { only_website: true, title: '欢迎', content: "恭喜新学员 <strong class='heart-green'>#{self.hello_name}</strong> 开始进入网站学习" }.to_json
  end
end
