class UpdateArticleWorker
  include Sidekiq::Worker

  def perform(article_id, article_params)
    article = Article.find(article_id)
    Redis.new.publish 'ws', {title: 'rails365 更新了文章', content: article.title, url: "https://www.rails365.net/articles/#{article.slug}"}.to_json
    Article.async_update(article_id, article_params)
  end
end
