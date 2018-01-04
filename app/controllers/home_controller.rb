class HomeController < ApplicationController
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

    @movies = Rails.cache.fetch "movies" do
      Movie.except_body_with_default.where(is_original: true).order('id DESC').limit(4)
    end

    # respond_to do |format|
    #   format.all { render :index, formats: [:html] }
    # end
  end

  def find
    if params[:tp] == "articles"
      redirect_to articles_path(tp: 'articles', search: params[:search])
    else
      redirect_to movies_path(tp: 'movies', search: params[:search])
    end
  end

  def about_us
  end
end
