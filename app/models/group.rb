require "babosa"
class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]
  mount_uploader :image, PhotoUploader
  has_many :articles, dependent: :nullify
  validates :name, presence: true

  def normalize_friendly_id(input)
    "#{PinYin.of_string(input).to_s.to_slug.normalize.to_s}"
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
