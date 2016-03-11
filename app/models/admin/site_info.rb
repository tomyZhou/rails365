class Admin::SiteInfo < ActiveRecord::Base
  validates :value, presence: true
end
