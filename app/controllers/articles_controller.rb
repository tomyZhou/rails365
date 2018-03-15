class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :find_changed_article, only: [:edit, :update, :destroy, :like]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :like]
  authorize_resource

  def index
    @articles =
      if params[:search].present?
        Article.search params[:search], fields: [:title, :body], highlight: true, misspellings: false, includes: [:group, :user], page: params[:page], per_page: 20
      elsif params[:find].present? && params[:find] == 'hot'
        Article.except_body_with_default.order('visit_count DESC').page(params[:page])
      else
        Article.except_body_with_default.order('id DESC').page(params[:page])
      end

    @groups = Rails.cache.fetch 'group_all' do
      Group.order(weight: :desc).to_a
    end

    @users = User.where(id: Article.pluck(:user_id).uniq)

    @playlists = Rails.cache.fetch 'article_playlists' do
      Playlist.where(is_original: true).order(weight: :desc).limit(4).to_a
    end

    @movies = Rails.cache.fetch "movies" do
      Movie.except_body_with_default.where(is_original: true).order('id DESC').limit(8)
    end

    # respond_to do |format|
    #   format.all { render :index, formats: [:html, :js] }
    # end
  end

  def show
    @title = @article.title

    @recommend_articles = @article.recommend_articles

    @comments = @article.fetch_comments
    @comment = @article.comments.build

    @books = Group.fetch_by_id(@article.group_id).fetch_books

    @article.increment_read_count
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

  def like
    current_user.toggle_like(@article)
    @article.update_like_count
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
      params.require(:article).permit(:title, :body, :group_id, :user_id, :weight, :is_home)
    else
      params.require(:article).permit(:title, :body, :group_id, :user_id, :is_home)
    end
  end
end
