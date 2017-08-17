class Comment < ActiveRecord::Base
  include IdentityCache::WithoutPrimaryIndex

  belongs_to :article
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, :user, presence: true
end
