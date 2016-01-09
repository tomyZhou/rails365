class UpdateArticleVisitCountJob < ActiveJob::Base
  queue_as :default

  def perform(article_id)
    Sidekiq.logger.info 'update article visit count begin'
    @article = Article.find(article_id)
    @article.visit_count += 1
    @article.save!(validate: false)
    Sidekiq.logger.info 'update article visit count end'
  end
end
