class Comment < ActiveRecord::Base
  include IdentityCache

  belongs_to :article
  belongs_to :movie
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  cache_belongs_to :commentable

  validates :body, :user, presence: true

  after_create :publish_create

  private

  def publish_create
    unless Rails.env.test?
      if self.commentable_type == "Article"
        Redis.new.publish 'ws', "文章 #{self.commentable.title} 创建了一条新的评论"
      end

      if self.commentable_type == "Movie"
        Redis.new.publish 'ws', "视频 #{self.commentable.title} 创建了一条新的评论"
      end
    end
  end
end
