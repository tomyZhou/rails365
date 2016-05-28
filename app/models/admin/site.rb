class Admin::Site < ActiveRecord::Base
  validates :name, :url, presence: true
  validates :name, uniqueness: true

  def self.cached_all
    Rails.cache.fetch('sites') { all.to_a }
  end

  after_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete 'sites'
  end
end
