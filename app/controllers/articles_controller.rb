class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    if params[:search].present?
      @articles = Article.except_body_with_default.search_by_title_or_body(params[:search]).order("id DESC").page(params[:page])
    else
      @articles = Article.except_body_with_default.order("id DESC").page(params[:page])
    end
    set_meta_tags title: '文章列表'
    respond_to do |format|
      format.all { render :index, formats: [:html]}
    end
  end

  def show
    set_meta_tags title: @article.title, description: @article.title, keywords: ENV['meta_keyword']
    @group_name = Rails.cache.fetch "article:#{@article.id}/group_name" do
      @article.group.try(:name) || ""
    end
    @recommend_articles = Rails.cache.fetch "article:#{@article.id}/recommend_articles" do
      Article.except_body_with_default.search_by_title_or_body(@group_name).order("visit_count DESC").limit(11).to_a
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

end
