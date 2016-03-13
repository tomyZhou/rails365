class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :find_changed_article, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  load_and_authorize_resource

  def index
    if params[:search].present?
      @articles = Article.except_body_with_default.search_by_title_or_body(params[:search]).order("id DESC").page(params[:page])
    else
      @articles = Article.except_body_with_default.order("id DESC").page(params[:page])
    end
    @title = '文章列表'
    respond_to do |format|
      format.all { render :index, formats: [:html]}
    end
  end

  def show
    @title = @article.title
    @group_name = Rails.cache.fetch "article:#{@article.id}/group_name" do
      @article.group.try(:name) || ""
    end
    @recommend_articles = Rails.cache.fetch "article:#{@article.id}/recommend_articles" do
      Article.except_body_with_default.search_by_title_or_body(@group_name).order("visit_count DESC").limit(11).to_a
    end
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.valid?
        CreateArticleWorker.perform_async(article_params, current_user.id)
        format.html { redirect_to articles_path, notice: 'Article was created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    UpdateArticleWorker.perform_async(params[:id], current_user.id, article_params)
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
      format.html { redirect_to articles_path, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_article
      @article = Rails.cache.fetch "article:#{params[:id]}" do
        Article.find(params[:id])
      end
      if request.path != article_path(@article)
        return redirect_to @article, :status => :moved_permanently
      end
    end

    def find_changed_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :body, :group_id, :user_id)
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
