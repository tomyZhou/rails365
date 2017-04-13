require 'babosa'
class App < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]
  mount_uploader :image, PhotoUploader

  include IdentityCache

  cache_index :slug, unique: true

  validates :name, presence: true, uniqueness: true
  validates :image, presence: true

  def normalize_friendly_id(input)
    PinYin.of_string(input).to_s.to_slug.normalize.to_s
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  after_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete 'apps'
    Rails.cache.delete 'app_all'
  end
end
