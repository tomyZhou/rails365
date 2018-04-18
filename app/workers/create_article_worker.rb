class CreateArticleWorker
  include Sidekiq::Worker

  def perform(user_id, article_params)
    logger.info article_params
    Article.async_create(user_id, article_params)
  end
end
