class CreateArticleJob < ActiveJob::Base
  queue_as :default

  def perform(article_params)
    Sidekiq.logger.info 'create article begin'
    @article = Article.new(article_params)
    @article.save!

    # 首页
    Rails.cache.delete "articles"
    Rails.cache.delete "hot_articles"
    Rails.cache.delete "groups"
    # 分类show页面的keyworkds meta
    Rails.cache.delete "group:#{@article.group_id}/tag_list"
    Rails.cache.delete "group:#{@article.group_id}"

    Rails.cache.delete "group:#{@article.group.try(:friendly_id)}"
    # 分类show页面下的文章列表
    Rails.cache.delete "group:#{@article.group_id}/articles"
    # 所有分类页面
    Rails.cache.delete "group_all"
    Sidekiq.logger.info 'create article end'
  end
end
