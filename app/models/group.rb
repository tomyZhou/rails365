require 'babosa'
class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]
  mount_uploader :image, PhotoUploader

  include IdentityCache
  has_many :articles, -> { order 'created_at DESC' }, dependent: :nullify

  cache_index :slug, unique: true

  def fetch_articles
    Rails.cache.fetch([name, 'articles']) { articles.to_a }
  end

  validates :name, presence: true, uniqueness: true
  validates :image, presence: true, on: :create

  def normalize_friendly_id(input)
    PinYin.of_string(input).to_s.to_slug.normalize.to_s
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  after_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete 'groups'
    Rails.cache.delete 'group_all'
  end
end
