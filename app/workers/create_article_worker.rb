class CreateArticleWorker

  include Sidekiq::Worker

  def perform(article_params, user_id)
    @user = User.find(user_id)
    @article = Article.new(article_params)
    @article.user_id = @user.id
    @article.save!
  end

end
