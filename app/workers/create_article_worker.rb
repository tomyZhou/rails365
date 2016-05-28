class CreateArticleWorker
  include Sidekiq::Worker

  def perform(article_params, user_id)
    @user = User.find(user_id)
    @article = Article.new(article_params)
    @article.user_id = @user.id
    @article.save!
    Redis.new.publish 'ws', "<#{@article.title}>文章于#{I18n.l @user.created_at, format: :long}创建成功"
  end
end
