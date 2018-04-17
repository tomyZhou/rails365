class UsersController < ApplicationController
  before_action :common, only: [:show, :articles, :like_articles, :movie_history]

  def index
    @users = Rails.cache.fetch 'active_users' do
      @users = User.order(active_weight: :desc, id: :desc).limit(100)
    end

    @title = '活跃学员'
  end

  def show
    @favourite_movies = @user.like_original_movies.order('id DESC').page(params[:page])
  end

  def articles
    @articles = @user.articles.order('id DESC').page(params[:page])
  end

  def like_articles
    @favourite_articles = @user.like_articles.order('id DESC').page(params[:page])
  end

  def movie_history
    ids = $redis.lrange("movies_#{@user.id}_history", 0, -1).uniq
    if ids.present?
      @favourite_movies = Movie.where(id: ids).order_by_ids(ids).page(params[:page])
    elsif @user.movie_history.present?
      @favourite_movies = Movie.where(id: @user.movie_history).order_by_ids(@user.movie_history).page(params[:page])
    else
      @favourite_movies = Movie.none.page(params[:page])
    end
    render :show
  end

  def change_profile
    Rails.cache.delete "current_user_[#{current_user.id}]" if current_user
  end

  def update_profile
    Rails.cache.delete "current_user_[#{current_user.id}]" if current_user
    if current_user.update(user_params)
      flash[:success] = "更新成功"
      redirect_to change_profile_users_path
    else
      render :change_profile
    end
  end

  private

  def common
    @user = User.find(params[:id])
    @favourite_movies_count = @user.like_original_movies.count
    @favourite_articles_count = @user.like_articles.count
    # @favourite_softs = @user.like_softs
  end

  def user_params
    params.require(:user).permit(:username, :avatar, :nickname, :company_name, :position)
  end
end
