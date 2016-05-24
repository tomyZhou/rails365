class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :find_changed_article, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  authorize_resource

  def index
    if params[:search].present?
      @articles = Article.search params[:search], fields: [:title, :body], highlight: true, order: {"_id": "desc"}, page: params[:page], per_page: 20
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
    @recommend_articles = Article.cached_recommend_articles(@article)
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)

    if @article.valid?
      CreateArticleWorker.perform_async(article_params, current_user.id)
      redirect_to articles_path, notice: '文章正在后台创建中，如果创建成功将会有消息提醒!'
    else
      render :new
    end
  end

  def update
    UpdateArticleWorker.perform_async(params[:id], current_user.id, article_params)
    redirect_to @article, notice: '文章正在后台更新中，如果更新成功将会有消息提醒!'
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: '文章成功删除!'
  end

  private

    def set_article
      @article = Article.fetch_by_slug!(params[:id])
    rescue ActiveRecord::RecordNotFound
      @article = Article.find(params[:id])
    end

    def find_changed_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :body, :group_id, :user_id)
    end

end
