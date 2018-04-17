require 'babosa'
class Article < ActiveRecord::Base
  searchkick highlight: [:title, :body]

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  act_as_likee
  include LikeConcern

  include PublicActivity::Common

  include IdentityCache
  cache_index :slug, unique: true

  belongs_to :group, counter_cache: true
  belongs_to :user
  has_many :comments, as: 'commentable'
  cache_has_many :comments, :inverse_name => :commentable

  scope :except_body_with_default, -> { select(:title, :is_top, :visit_count, :like_count, :created_at, :updated_at, :group_id, :slug, :id, :user_id, :weight, :is_home) }

  def self.increment_random_read_count(n)
    self.last(n.to_i).each do |article|
      $redis.set("user_#{article.id}_count", article.read_count.to_i + rand(10))
    end
  end

  def self.async_create(user_id, article_params)
    user = User.find(user_id)
    article = self.new(article_params)
    article.user_id = user.id
    article.save!

    # 创建动态
    article.create_activity :create, owner: user
  end

  def self.async_update(article_id, article_params)
    article = self.find(article_id)
    user_id = article.user_id
    article.update!(article_params)
    article.user_id = user_id
    article.save(validate: false)
  end

  validates :title, :body, :group_id, :user_id, presence: true
  validates :title, uniqueness: true

  def recommend_articles
    Rails.cache.fetch "recommend_articles_#{self.id}" do
      self.similar(fields: [:title], limit: 10)
    end
  end

  def normalize_friendly_id(input)
    PinYin.of_string(input).to_s.to_slug.normalize.to_s
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  after_commit :clear_cache
  before_update :clear_before_updated_cache
  after_update :clear_after_updated_cache
  after_create :publish_create

  before_save do
    # 引发 ActiveModel::Dirty 的 change
    self.title_will_change!
    self.title.auto_correct!
  end

  include ReadCountConcern

  private

  def publish_create
    unless Rails.env.test?
      Redis.new.publish 'ws', { title: 'rails365 上传了文章', content: self.title, url: "https://www.rails365.net/articles/#{self.slug}" }.to_json
    end
  end

  def clear_cache
    # 首页
    Rails.cache.delete 'articles'
    Rails.cache.delete "top_articles"
    Rails.cache.delete 'groups'
    # 所有分类页面
    Rails.cache.delete 'group_all'
    # 所属的分类
    IdentityCache.cache.delete(group.primary_cache_index_key)
    # 分类show页面下的文章列表
    Rails.cache.delete [group.slug, 'articles']

    Rails.cache.delete "article_users"
    Rails.cache.delete "new_articles"
  end

  def clear_before_updated_cache
    if group_id_changed?
      group = Group.find(group_id_was)
      Rails.cache.delete [group.slug, 'articles']
      IdentityCache.cache.delete(group.primary_cache_index_key)
    end
  end

  def clear_after_updated_cache
    # 文章show页面右侧推荐文章列表
    Rails.cache.delete "recommend_articles_#{self.id}"
  end
end
