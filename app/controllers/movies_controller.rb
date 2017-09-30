class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]
  before_action :find_changed_movie, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  authorize_resource

  def index
    @movies =
      if params[:search].present?
        Movie.search params[:search], fields: [:title, :body], highlight: true, misspellings: false, includes: [:playlist, :user], page: params[:page], per_page: 20
      else
        Movie.except_body_with_default.order('id DESC').page(params[:page])
      end

    @title = '文章列表'

    respond_to do |format|
      format.all { render :index, formats: [:html] }
    end
  end

  def show
    @title = @movie.title

    @recommend_movies = @movie.recommend_movies

    @comments = @movie.fetch_comments
    logger.info @movie.id
    logger.info @comments
    @comment = @movie.comments.build

    @site_info_home_desc = Playlist.fetch_by_id(@movie.playlist_id).try(:desc)
  end

  def new
    @movie = Movie.new
  end

  def edit
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.valid?
      CreateMovieWorker.perform_async(current_user.id, movie_params)
    end
  end

  def update
    UpdateMovieWorker.perform_async(params[:id], movie_params)
    render 'update.js.erb'
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, notice: '视频成功删除!'
  end

  private

  def set_movie
    @movie = Movie.fetch_by_slug!(params[:id])
  rescue ActiveRecord::RecordNotFound
    @movie = Movie.find(params[:id])
  end

  def find_changed_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    if current_user && current_user.super_admin?
      params.require(:movie).permit(:title, :body, :playlist_id, :user_id, :weight)
    else
      params.require(:movie).permit(:title, :body, :playlist_id, :user_id)
    end
  end
end
