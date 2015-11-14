class Group < ActiveRecord::Base
  mount_uploader :image, PhotoUploader
  has_many :articles, dependent: :nullify
  validates :name, presence: true
end
