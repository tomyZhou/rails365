class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :find_changed_article, only: [:edit, :update, :destroy, :like]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :like]
  authorize_resource

  def index
    ahoy.track "文章列表", {language: "Ruby"}

    @articles =
      if params[:search].present?
        Article.search params[:search], fields: [:title, :body], boost_by: [:visit_count], highlight: true, misspellings: false, includes: [:group, :user], page: params[:page], per_page: 20
      elsif params[:find].present? && params[:find] == 'hot'
        Article.except_body_with_default.order('visit_count DESC').page(params[:page])
      else
        Article.except_body_with_default.order('id DESC').page(params[:page])
      end

    @top_articles = Cache.top_articles

    @groups = Cache.group_all

    # 文章原创用户
    @users = User.where(id: Article.pluck(:user_id).uniq)
  end

  def show
    @title = @article.title

    ahoy.track @title, {language: "Ruby"}

    @recommend_articles = @article.recommend_articles

    @comments = @article.fetch_comments
    @comment = @article.comments.build

    @books = Group.fetch_by_id(@article.group_id).fetch_books

    if !(current_user && current_user.super_admin?)
      @article.increment_read_count

      # 记录哪些文章被浏览过
      @article.remember_visit_id
    end
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
    if @article.liked_by?(current_user) && !current_user.super_admin?
      @article.create_activity key: 'article.like', owner: current_user

      Redis.new.publish 'ws', { only_website: true, title: '获得喜欢', content: "学员 <strong>#{current_user.hello_name}</strong> 喜欢了 #{@article.title}" }.to_json
      SendSystemHistory.send_system_history("学员 <a href=#{movie_history_user_path(current_user)}>#{current_user.hello_name}</a>", "喜欢", "<a href=#{article_path(@article)}>#{@article.title}</a>")
    end
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
      params.require(:article).permit(:title, :is_top, :body, :group_id, :user_id, :weight, :is_home)
    else
      params.require(:article).permit(:title, :is_top, :body, :group_id, :user_id, :is_home)
    end
  end
end
