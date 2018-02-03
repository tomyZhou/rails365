require 'babosa'
class Article < ActiveRecord::Base
  searchkick highlight: [:title, :body]

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  act_as_likee
  include LikeConcern

  include IdentityCache
  cache_index :slug, unique: true

  belongs_to :group, counter_cache: true
  belongs_to :user
  has_many :comments, as: 'commentable'
  cache_has_many :comments, :inverse_name => :commentable

  scope :except_body_with_default, -> { select(:title, :like_count, :created_at, :updated_at, :group_id, :slug, :id, :user_id, :weight, :is_home).includes(:group) }

  def self.async_create(user_id, article_params)
    user = User.find(user_id)
    article = self.new(article_params)
    article.user_id = user.id
    article.save!
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
    group = Group.fetch(self.group_id)
    Rails.cache.fetch "recommend_articles_#{group.slug}" do
      self.class.except_body_with_default.search(group.name, fields: [:title, :body], limit: 11)
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

  # 订阅量
  def self.update_visit_count
    self.find_each do |article|
      if article.visit_count != article.read_count.to_i
        article.visit_count = article.read_count.to_i
        article.save validate: false
      end
    end
  end

  def self.init_random_read_count
    self.find_each do |article|
      article.visit_count = rand(1000)
      article.save validate: false
      $redis.set("user_#{article.id}_count", article.visit_count)
    end
  end

  include ReadCountConcern

  private

  def publish_create
    unless Rails.env.test?
      Redis.new.publish 'ws', {title: 'rails365 上传了文章', content: self.title, url: "https://www.rails365.net/articles/#{self.slug}"}.to_json
    end
  end

  def clear_cache
    # 首页
    Rails.cache.delete 'articles'
    Rails.cache.delete 'hot_articles'
    Rails.cache.delete 'groups'
    # 所有分类页面
    Rails.cache.delete 'group_all'
    # 所属的分类
    IdentityCache.cache.delete(group.primary_cache_index_key)
    # 分类show页面下的文章列表
    Rails.cache.delete [group.slug, 'articles']
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
    Rails.cache.delete "recommend_articles_#{self.group.slug}"
  end
end
