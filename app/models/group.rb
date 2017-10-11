require 'babosa'
class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]

  include IdentityCache
  cache_index :slug, unique: true

  has_many :articles, -> { order 'created_at DESC' }, dependent: :nullify
  has_many :books
  cache_has_many :books, :embed => true

  mount_uploader :image, PhotoUploader

  validates :name, presence: true, uniqueness: true
  validates :image, presence: true, on: :create

  def fetch_articles
    Rails.cache.fetch([self.slug, 'articles']) { articles.reorder(weight: :asc, id: :desc, slug: :asc).to_a }
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
    Rails.cache.delete 'groups'
    Rails.cache.delete 'group_all'
  end
end
