class CreateArticleWorker
  include Sidekiq::Worker

  def perform(article_params, user_id)
    Article.async_create(article_params, user_id)
  end
end
