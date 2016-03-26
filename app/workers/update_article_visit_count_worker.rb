class UpdateArticleVisitCountWorker
  include Sidekiq::Worker
  def perform(article_id)
    @article = Article.find_by(id: article_id)
    if @article.present?
      @article.visit_count += 1
      @article.save!(validate: false)
    end
  end
end
