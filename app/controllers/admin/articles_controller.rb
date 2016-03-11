class Admin::ArticlesController < Admin::BaseController
  before_action :set_article, only: [:edit, :update, :destroy]

  def index
    @articles = Article.includes(:group).order("id DESC").page(params[:page])
    render 'articles/index'
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.valid?
        CreateArticleWorker.perform_async(article_params)
        format.html { redirect_to articles_path, notice: 'Article was created.' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    UpdateArticleWorker.perform_async(params[:id], article_params)
    respond_to do |format|
      format.html { redirect_to @article, notice: 'Article was updated.' }
    end
  end

  def destroy
    @article.destroy
    expired_common
    # 分类show页面下的文章列表
    Rails.cache.delete "group:#{@article.group_id}/articles"
    Rails.cache.delete "group:#{@article.group.try(:friendly_id)}"

    respond_to do |format|
      format.html { redirect_to admin_root_path, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body, :group_id)
  end

  def expired_common
    # 首页
    Rails.cache.delete "articles"
    Rails.cache.delete "hot_articles"
    Rails.cache.delete "groups"
    # 分类show页面的keyworkds meta
    Rails.cache.delete "group:#{@article.group_id}"
  end

end
