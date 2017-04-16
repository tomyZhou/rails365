require 'babosa'
class Article < ActiveRecord::Base
  searchkick highlight: [:title, :body]

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  include IdentityCache
  cache_index :slug, unique: true
  belongs_to :group, counter_cache: true
  belongs_to :user

  scope :except_body_with_default, -> { select(:title, :created_at, :updated_at, :group_id, :slug, :id, :user_id).includes(:group) }

  def self.cached_recommend_articles(article)
    group_name = article.group.name || 'ruby'
    Rails.cache.fetch [:slug, 'recommend_articles', group_name] do
      Article.except_body_with_default.search(group_name, limit: 11)
    end
  end

  def self.async_create(user_id, article_params)
    user = User.find(user_id)
    article = Article.new(article_params)
    article.user_id = user.id
    article.save!
  end

  def self.async_update(article_id, article_params)
    article = Article.find(article_id)
    user_id = article.user_id
    article.update!(article_params)
    article.user_id = user_id
    article.save(validate: false)
  end

  validates :title, :body, :group_id, :user_id, presence: true
  validates :title, uniqueness: true

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

  private

  def publish_create
    unless Rails.env.test?
      Redis.new.publish 'ws', "<#{title}>文章于#{I18n.l created_at, format: :long}创建成功"
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
    Rails.cache.delete [group.name, 'articles']
  end

  def clear_before_updated_cache
    if group_id_changed?
      group = Group.find(group_id_was)
      Rails.cache.delete [group.name, 'articles']
      IdentityCache.cache.delete(group.primary_cache_index_key)
    end
  end

  def clear_after_updated_cache
    # 文章show页面右侧推荐文章列表
    Rails.cache.delete [slug, 'recommend_articles', group.name]

    unless Rails.env.test?
      Redis.new.publish 'ws', "<#{title}>文章于#{I18n.l created_at, format: :long}更新成功"
    end
  end
end
