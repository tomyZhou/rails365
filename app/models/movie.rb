require 'babosa'
class Movie < ApplicationRecord
  searchkick

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  include IdentityCache
  cache_index :slug, unique: true

  act_as_likee
  include LikeConcern

  # include PublicActivity::Model
  # tracked owner: ->(controller, model) { controller && controller.current_user }
  include PublicActivity::Common

  belongs_to :playlist, counter_cache: true, touch: true
  belongs_to :serial, counter_cache: true, touch: true
  belongs_to :user
  has_many :comments, as: 'commentable'
  cache_has_many :comments, :inverse_name => :commentable

  scope :original, -> { where(is_original: true) }

  mount_uploader :image, VideoUploader

  validates :title, :body, :playlist_id, :user_id, presence: true
  validates :title, uniqueness: true
  validates :image, presence: true, on: :create

  def self.increment_random_read_count(n)
    Rails.cache.delete 'movies'
    self.last(n.to_i).each do |movie|
      $redis.set("user_movie_#{movie.id}_count", movie.read_count.to_i + rand(10))
    end
  end

  # https://stackoverflow.com/questions/1309624/simulating-mysqls-order-by-field-in-postgresql
  def self.order_by_ids(ids)
    order_by = ["CASE"]
    ids.each_with_index do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << "END"
    order(order_by.join(" "))
  end

  def recommend_movies
    Rails.cache.fetch "recommend_movies_1#{self.id}" do
      self.similar(fields: [:title], limit: 3, where: { is_original: true })
    end
  end

  def has_read_priv?(current_user)
    # 如果不用付费可以直接观看
    return true if !self.is_paid?
    # 需要付费，但是没有登录，不可以观看
    return false if current_user.nil?
    # 超级管理员和付费的用户可以看付费的视频
    # 其他人不能观看付费的视频
    current_user.is_paid? || current_user.super_admin? ? true : false
  end

  def playlist_movies
    playlist = Playlist.fetch(self.playlist_id)
    Rails.cache.fetch "playlist_movies_#{playlist.slug}" do
      self.class.includes(:playlist).where(playlist: playlist).order(weight: :asc, id: :asc)
    end
  end

  def prev_movie
    playlist.movies.where("weight < ?", weight).first
  end

  def next_movie
    playlist.movies.where("weight > ?", weight).last
  end

  def login_visit_history(current_user)
    if !current_user.nil? && !current_user.super_admin?
      # 记录所有浏览过视频的用户的 id
      user_view_ids = $redis.lrange "user_view_ids", 0, -1
      if !user_view_ids.present? || (user_view_ids.present? && !user_view_ids.include?(current_user.id.to_s))
        $redis.lpush "user_view_ids", current_user.id
      end

      # 浏览记录
      $redis.lpush "movies_#{current_user.id}_history", self.id
      $redis.ltrim "movies_#{current_user.id}_history", 0, 99

      Redis.new.publish 'ws', { only_website: true, title: '努力学习', content: "学员 <strong>#{current_user.hello_name}</strong> 正在学习 #{self.title}" }.to_json

      SendSystemHistory.send_system_history("学员 <a href='/users/#{current_user.id}/movie_history'>#{current_user.hello_name}</a>", "正在学习", "<a href='/movies/#{self.slug}'>#{self.title}</a>")
    else
      return if !current_user.nil? && current_user.super_admin?

      # guest_access_movie = Admin::SiteInfo.fetch_by_key('guest_access_movie').try(:value)
      #
      # if guest_access_movie.presence != '空'
      #   Redis.new.publish 'ws', { only_website: true, title: '努力学习', content: "游客 正在学习 #{@movie.title}" }.to_json
      # end

      SendSystemHistory.send_system_history("游客", "正在学习", "<a href='/movies/#{self.slug}'>#{self.title}</a>")
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

  include BaiduDownloadConcern

  private

  def publish_create
    unless Rails.env.test?
      Redis.new.publish 'ws', { title: 'rails365 上传了视频', content: self.title, url: "https://www.rails365.net/movies/#{self.slug}" }.to_json
    end
  end

  def clear_cache
    # 首页
    Rails.cache.delete 'movies_10'
    Rails.cache.delete 'movies_3'
    Rails.cache.delete 'playlists'
    # 所有分类页面
    Rails.cache.delete 'playlist_all'
    # 所属的分类
    IdentityCache.cache.delete(playlist.primary_cache_index_key)
    # 分类show页面下的视频列表
    Rails.cache.delete [playlist.slug, 'movies']
  end

  def clear_before_updated_cache
    if playlist_id_changed?
      playlist = Playlist.find(playlist_id_was)
      Rails.cache.delete [playlist.slug, 'movies']
      IdentityCache.cache.delete(playlist.primary_cache_index_key)
    end
  end

  def clear_after_updated_cache
    # 文章show页面右侧推荐视频列表
    Rails.cache.delete "recommend_movies_#{self.id}"

    Rails.cache.delete "playlist_movies_#{playlist.slug}"
  end
end
