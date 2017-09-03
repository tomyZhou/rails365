class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :find_changed_article, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  authorize_resource

  def index
    @articles =
      if params[:search].present?
        Article.search params[:search], fields: [:title, :body], highlight: true, misspellings: false, includes: [:group, :user], page: params[:page], per_page: 20
      else
        Article.except_body_with_default.order('id DESC').page(params[:page])
      end

    @title = '文章列表'

    respond_to do |format|
      format.all { render :index, formats: [:html] }
    end
  end

  def show
    @title = @article.title

    @recommend_articles = @article.recommend_articles

    @comments = @article.fetch_comments
    @comment = @article.comments.build

    @site_info_home_desc = Group.fetch_by_id(@article.group_id).try(:desc)

    @books = Group.fetch_by_id(@article.group_id).fetch_books
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)

    if @article.valid?
      CreateArticleWorker.perform_async(current_user.id, article_params)
    end
  end

  def update
    UpdateArticleWorker.perform_async(params[:id], article_params)
    render 'update.js.erb'
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
    if current_user && current_user.super_admin?
      params.require(:article).permit(:title, :body, :group_id, :user_id, :weight)
    else
      params.require(:article).permit(:title, :body, :group_id, :user_id)
    end
  end
end
