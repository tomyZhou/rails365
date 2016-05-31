class CreateArticleWorker
  include Sidekiq::Worker

  def perform(user_id, article_params)
    Article.async_create(user_id, article_params)
  end
end
