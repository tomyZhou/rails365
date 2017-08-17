class Comment < ActiveRecord::Base
  include IdentityCache::WithoutPrimaryIndex

  belongs_to :article
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, :user, presence: true

  after_create :publish_create

  private

  def publish_create
    unless Rails.env.test?
      Redis.new.publish 'ws', "文章 #{self.article.title} 创建了一条新的评论"
    end
  end
end
