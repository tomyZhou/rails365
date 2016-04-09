class CreateArticleWorker

  include Sidekiq::Worker

  def perform(article_params, user_id)
    @user = User.find(user_id)
    @article = Article.new(article_params)
    @article.user_id = @user.id
    @article.save!

    # 首页
    Rails.cache.delete "articles"
    Rails.cache.delete "hot_articles"
    Rails.cache.delete "groups"
    # 分类show页面的keyworkds meta
    Rails.cache.delete "group:#{@article.group_id}"

    Rails.cache.delete "group:#{@article.group.try(:friendly_id)}"
    # 分类show页面下的文章列表
    Rails.cache.delete [@article.group.try(:name), "articles"]
    # 所有分类页面
    Rails.cache.delete "group_all"
  end

end
