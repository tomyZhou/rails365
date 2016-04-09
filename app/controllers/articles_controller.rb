class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :find_changed_article, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  authorize_resource

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
      redirect_to articles_path, notice: 'Article was created.'
    else
      render :new
    end
  end

  def update
    UpdateArticleWorker.perform_async(params[:id], current_user.id, article_params)
    redirect_to @article, notice: 'Article was updated.'
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: 'Article was successfully destroyed.'
  end

  private

    def set_article
      @article = Article.fetch_by_slug!(params[:id])

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

end
