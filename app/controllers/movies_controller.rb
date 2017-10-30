class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]
  before_action :find_changed_movie, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  authorize_resource

  def index
    @movies = Movie.except_body_with_default.order('id DESC').page(params[:page])

    @playlists = Rails.cache.fetch 'playlist_all' do
      Playlist.order(weight: :desc).to_a
    end

    @title = '视频列表'

    respond_to do |format|
      format.all { render :index, formats: [:html] }
    end
  end

  def show
    @title = @movie.title

    # @recommend_movies = @movie.recommend_movies

    @comments = @movie.fetch_comments
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

    if @movie.save
      flash[:success] = "创建成功"
      redirect_to movie_path(@movie)
    else
      render :new
    end
  end

  def update
    if @movie.update(movie_params)
      flash[:success] = "更新成功"
      redirect_to movie_path(@movie)
    else
      render :edit
    end
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
      params.require(:movie).permit(:title, :play_time, :body, :playlist_id, :user_id, :weight, :image, :mp4_url, :youtube_url, :is_finished)
    else
      params.require(:movie).permit(:title, :play_time, :body, :playlist_id, :user_id, :image, :mp4_url, :youtube_url, :is_finished)
    end
  end
end
