class Admin::Site < ActiveRecord::Base
  validates :name, :url, presence: true
  validates :name, uniqueness: true

  def self.cache_objects
    Rails.cache.fetch("sites") do
      all.to_a
    end
  end

  after_save :clear_cache
  after_destroy :clear_cache

private
  def clear_cache
    Rails.cache.delete "sites"
  end
end
