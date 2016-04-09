require "babosa"
class Article < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_title_or_body,
                  :against => {
                    :title => 'A',
                    :body => 'B'
                  },
                  :using => {
                    :tsearch => {:dictionary => "testzhcfg", :prefix => true, :negation => true}
                  }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  include IdentityCache
  cache_index :slug, :unique => true
  belongs_to :group, counter_cache: true
  belongs_to :user

  scope :except_body_with_default, -> { select(:title, :created_at, :updated_at, :group_id, :slug, :id, :user_id).includes(:group) }

  def self.cached_recommend_articles(article)
    group_name = article.group.name || "ruby"
    Rails.cache.fetch [:slug, "recommend_articles", group_name] do
      Article.except_body_with_default.search_by_title_or_body(group_name).order("visit_count DESC").limit(11).to_a
    end
  end

  validates :title, :body, :group_id, :user_id, presence: true
  validates :title, uniqueness: true

  def normalize_friendly_id(input)
    "#{PinYin.of_string(input).to_s.to_slug.normalize.to_s}"
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  after_commit :clear_cache
  before_update :clear_before_updated_cache
  after_update :clear_after_updated_cache

  private

  def clear_cache
    # 首页
    Rails.cache.delete "articles"
    Rails.cache.delete "hot_articles"
    Rails.cache.delete "groups"
    # 所有分类页面
    Rails.cache.delete "group_all"
    # 所属的分类
    IdentityCache.cache.delete(group.primary_cache_index_key)
    # 分类show页面下的文章列表
    Rails.cache.delete [group.name, 'articles']
  end

  def clear_before_updated_cache
    Rails.cache.delete [group.name, "articles"]
    IdentityCache.cache.delete(group.primary_cache_index_key)
  end

  def clear_after_updated_cache
    # 文章show页面右侧推荐文章列表
    Rails.cache.delete [slug, "recommend_articles", group.name]
  end

end
