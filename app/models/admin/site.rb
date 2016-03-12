class Admin::Site < ActiveRecord::Base
  validates :name, :url, presence: true
  validates :name, uniqueness: true
end
