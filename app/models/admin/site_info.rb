class Admin::SiteInfo < ActiveRecord::Base
  acts_as_cached(version: 1, expires_in: 1.year)
  validates :value, presence: true
end
