class Comment < ApplicationRecord
  include IdentityCache

  belongs_to :article, optional: true
  belongs_to :movie, optional: true
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  cache_belongs_to :commentable

  # include PublicActivity::Model
  # tracked owner: ->(controller, model) { controller && controller.current_user }
  include PublicActivity::Common

  validates :body, :user, presence: true

  after_create :publish_create

  private

  def publish_create
    unless Rails.env.test?
      if self.commentable_type == "Article"
        ActionCable.server.broadcast \
          'web_channel', { title: '获得评论',
                           content: "学员 <strong>#{self.user.hello_name}</strong> 评论了文章 #{self.commentable.title}"
        }.to_json
      end

      if self.commentable_type == "Movie"
        ActionCable.server.broadcast \
          'web_channel', { title: '获得评论',
                           content: "学员 <strong>#{self.user.hello_name}</strong> 评论了视频 #{self.commentable.title}"
        }.to_json

        SendSystemHistory.send_system_history("学员 #{self.user.hello_name}", "评论了", self.commentable.title)
      end
    end
  end
end
