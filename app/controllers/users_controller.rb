class UsersController < ApplicationController
  def show
    common
  end

  def articles
    common
  end

  def change_profile
    @no_search = true
  end

  def update_profile
    if current_user.update(user_params)
      Rails.cache.delete "current_user_[#{current_user.id}]" if current_user
      flash[:success] = "更新成功"
      redirect_to change_profile_users_path
    else
      render :change_profile
    end
  end

  private

  def common
    @user = User.find(params[:id])
    @favourite_articles = @user.like_articles
    @favourite_movies = @user.like_movies
    @favourite_softs = @user.like_softs
    @articles = @user.articles.order('id DESC').page(params[:page])
    @no_search = true
  end

  def user_params
    params.require(:user).permit(:username, :avatar)
  end
end
