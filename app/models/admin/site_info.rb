class Admin::SiteInfo < ActiveRecord::Base
  include IdentityCache
  cache_index :key, :unique => true
  validates :value, presence: true
end
