class Admin::ArticlesController < Admin::BaseController
  before_action :set_article, only: [:edit, :update, :destroy]

  def index
    @articles = Article.includes(:group).order("id DESC").page(params[:page])
    render 'articles/index'
  end

  def unpublished
    @articles = Article.unpublished.includes(:group).order("id DESC").page(params[:page])
    render 'articles/index'
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        expired_common
        # 所有分类页面
        Rails.cache.delete "group_all"
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        expired_common
        # 文章搜索用的group name
        Rails.cache.delete "article:#{@article.id}/group_name"
        # 文章show页面右侧推荐文章列表
        Rails.cache.delete "article:#{@article.id}/recommend_articles"
        # 文章show页面右侧标签
        Rails.cache.delete "article:#{@article.id}/tags"
        # 文章
        Rails.cache.delete "article:#{@article.slug}"

        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    expired_common

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
    params.require(:article).permit(:title, :body, :published, :group_id, :tag_list, :meta_description)
  end

  def expired_common
    # 首页
    Rails.cache.delete "articles"
    Rails.cache.delete "hot_articles"
    Rails.cache.delete "groups"
    # 分类show页面下的文章列表
    Rails.cache.delete "group:#{@article.group_id}/articles"
    # 分类show页面的keyworkds meta
    Rails.cache.delete "group:#{@article.group_id}/tag_list"
    Rails.cache.delete "group:#{@article.group_id}"
  end

end
