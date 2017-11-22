class UsersController < ApplicationController
  def show
    common
  end

  def articles
    common
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
end
