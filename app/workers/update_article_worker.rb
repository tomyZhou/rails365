class UpdateArticleWorker

  include Sidekiq::Worker

  def perform(article_id, user_id, article_params)
    @user = User.find(user_id)
    @article = Article.find(article_id)
    @article.user_id = @user.id
    @article.update!(article_params)
  end

end
