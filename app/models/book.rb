class Book < ActiveRecord::Base
  include IdentityCache
  belongs_to :group

  mount_uploader :image, AvatarUploader

  validates :name, :desc, :url, presence: true
  validates :image, presence: true, on: :create

  after_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete 'books'
    Rails.cache.delete 'book_all'
  end
end
