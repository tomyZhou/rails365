class UpdateArticleWorker
  include Sidekiq::Worker

  def perform(article_id, article_params)
    Article.async_update(article_id, article_params)
  end
end
