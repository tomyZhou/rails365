require 'babosa'
class Playlist < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]

  include IdentityCache
  cache_index :slug, unique: true

  has_many :movies, -> { order 'weight DESC' }, dependent: :nullify

  def self.playlist_movies_list(name)
    puts "## #{name}"
    puts

    playlist = self.find_by(name: name)
    if playlist
      playlist.movies.reorder(weight: :asc, id: :asc).each do |movie|
        puts "[#{movie.title}](https://www.rails365.net#{Rails.application.routes.url_helpers.movie_path(movie)})#{movie.is_paid ? '「Pro」' : nil}"
        puts
      end
    else
      puts "没有找到 #{name}"
      puts
    end
  end

  def self.all_movies_list
    self.where(is_original: true).order(weight: :asc).each do |playlist|
      self.playlist_movies_list(playlist.name)
    end
  end

  mount_uploader :image, VideoUploader

  validates :name, presence: true, uniqueness: true
  validates :image, presence: true, on: :create

  def fetch_movies
    Rails.cache.fetch([self.slug, 'movies']) { movies.reorder(weight: :asc, slug: :asc).to_a }
  end

  def normalize_friendly_id(input)
    PinYin.of_string(input).to_s.to_slug.normalize.to_s
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  after_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete 'playlists'
    Rails.cache.delete 'playlist_all'
    Rails.cache.delete 'article_playlists'
  end
end
