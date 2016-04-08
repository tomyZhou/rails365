require "babosa"
class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]
  mount_uploader :image, PhotoUploader
  has_many :articles, dependent: :nullify
  validates :name, presence: true

  acts_as_cached(version: 1, expires_in: 1.month)

  def cached_articles
    Rails.cache.fetch("group:#{id}/articles") { articles.to_a }
  end

  def normalize_friendly_id(input)
    "#{PinYin.of_string(input).to_s.to_slug.normalize.to_s}"
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  after_commit :clear_cache

private
  def clear_cache
    expire_second_level_cache
    Rails.cache.delete "groups"
    Rails.cache.delete "group_all"
  end

end
