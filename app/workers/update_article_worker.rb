class UpdateArticleWorker

  include Sidekiq::Worker

  def perform(article_id, user_id, article_params)
    @user = User.find(user_id)
    @article = Article.find(article_id)
    @article.user_id = @user.id
    @article.update!(article_params)
    Redis.new.publish "ws", "<#{@article.title}>文章于#{I18n.l @user.created_at, :format => :long}更新成功"
  end

end
