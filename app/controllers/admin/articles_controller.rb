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
    Rails.cache.delete "articles"
    Rails.cache.delete "hot_articles"

    respond_to do |format|
      if @article.save
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
        Rails.cache.delete "articles"
        Rails.cache.delete "hot_articles"
        Rails.cache.delete "article:#{@article.id}/group_name"
        Rails.cache.delete "article:#{@article.id}/recommend_articles"
        Rails.cache.delete "article:#{@article.id}/tags"

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
    Rails.cache.delete "articles"
    Rails.cache.delete "hot_articles"

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
    params.require(:article).permit(:title, :body, :published, :group_id, :tag_list)
  end

end
