class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]
  before_action :find_changed_movie, only: [:edit, :update, :destroy, :like]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :like]
  authorize_resource

  def index
    if params[:search].present?
      @movies = Movie.search params[:search], where: {is_original: true}, fields: [:title, :body], includes: [:playlist], page: params[:page], per_page: 20
    elsif params[:name].present?
      @serial = Serial.find(params[:name])
      @movies = @serial.movies.except_body_with_default.where(is_original: true).order('id DESC').page(params[:page]).per(20)
    elsif params[:filter].present? && params[:filter] == 'original'
      @movies = Movie.except_body_with_default.order('id DESC').page(params[:page]).per(20)
    elsif params[:filter].present? && params[:filter] == 'other'
      @movies = Movie.except_body_with_default.where(is_original: true).where("serial_id is null").order('id DESC').page(params[:page]).per(20)
    else
      @movies = Movie.except_body_with_default.where(is_original: true).order('id DESC').page(params[:page]).per(20)
    end

    @serials = Rails.cache.fetch('serials') do
      Serial.order(weight: :desc).to_a
    end

    @title = 'web 编程视频'

    # respond_to do |format|
    #   format.all { render :index, formats: [:html] }
    # end
  end

  def show
    @title = @movie.title

    # @recommend_movies = @movie.recommend_movies
    @playlist_movies = @movie.playlist_movies

    @comments = @movie.fetch_comments
    @comment = @movie.comments.build

    # @site_info_home_desc = Playlist.fetch_by_id(@movie.playlist_id).try(:desc)

    @movie.increment_read_count
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
      Redis.new.publish 'ws', {title: 'rails365 更新了视频', content: @movie.title, url: "https://www.rails365.net/articles/#{@movie.slug}"}.to_json
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

  def like
    current_user.toggle_like(@movie)
    @movie.update_like_count
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
      params.require(:movie).permit!
    else
      params.require(:movie).permit(:title, :mp4_name, :author, :play_time, :body, :playlist_id, :user_id, :image, :mp4_url, :youtube_url, :is_finished, :download_url)
    end
  end
end
