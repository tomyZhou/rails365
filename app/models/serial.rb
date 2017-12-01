require 'babosa'
class Serial < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]

  include IdentityCache
  cache_index :slug, unique: true

  has_many :movies, -> { order 'created_at DESC' }, dependent: :nullify

  validates :name, presence: true, uniqueness: true

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
    Rails.cache.delete 'serials'
  end
end
