class UpdateArticleVisitCountWorker
  include Sidekiq::Worker
  def perform(article_id)
    logger.info 'update article visit count begin'
    @article = Article.find_by(id: article_id)
    if @article.present?
      @article.visit_count += 1
      @article.save!(validate: false)
      logger.info 'article is not exists'
    else
      logger.info 'update article visit count end'
    end
  end
end
