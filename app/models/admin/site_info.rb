class Admin::SiteInfo < ActiveRecord::Base
  acts_as_cached(version: 1, expires_in: 1.year)
  validates :value, presence: true

  after_update :clear_cache

private
  def clear_cache
    Rails.cache.delete "slc/admin_site_infos/#{self.id}/1"
  end
end
