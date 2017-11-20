class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @favourite_movies = @user.like_movies
    @articles = @user.articles.order('id DESC').page(params[:page])
  end

  def articles
    @user = User.find(params[:id])
    @favourite_movies = @user.like_movies
    @articles = @user.articles.order('id DESC').page(params[:page])
  end
end
