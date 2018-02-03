require 'babosa'
class Movie < ActiveRecord::Base
  searchkick highlight: [:title, :body]

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  include IdentityCache
  cache_index :slug, unique: true

  act_as_likee
  include LikeConcern

  belongs_to :playlist, counter_cache: true, touch: true
  belongs_to :serial, counter_cache: true
  belongs_to :user
  has_many :comments, as: 'commentable'
  cache_has_many :comments, :inverse_name => :commentable

  scope :except_body_with_default, -> { select(:title, :like_count, :serial_id, :is_original, :created_at, :updated_at, :is_finished, :playlist_id, :image, :slug, :id, :play_time, :user_id, :weight).includes(:playlist) }

  mount_uploader :image, VideoUploader

  validates :title, :body, :playlist_id, :user_id, presence: true
  validates :title, uniqueness: true
  validates :image, presence: true, on: :create

  # def recommend_movies
  #   playlist = Playlist.fetch(self.playlist_id)
  #   Rails.cache.fetch "recommend_movies_#{playlist.slug}" do
  #     self.class.except_body_with_default.search(playlist.name, fields: [:title, :body], limit: 11)
  #   end
  # end

  def playlist_movies
    playlist = Playlist.fetch(self.playlist_id)
    Rails.cache.fetch "playlist_movies_#{playlist.slug}" do
      self.class.except_body_with_default.where(playlist: playlist).order(weight: :asc, id: :asc)
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
      Redis.new.publish 'ws', {title: 'rails365 上传了视频', content: self.title, url: "https://www.rails365.net/movies/#{self.slug}"}.to_json
    end
  end

  def clear_cache
    # 首页
    Rails.cache.delete 'movies'
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
    # Rails.cache.delete "recommend_movies_#{playlist.slug}"

    Rails.cache.delete "playlist_movies_#{playlist.slug}"
  end
end
