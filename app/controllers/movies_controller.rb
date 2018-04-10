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
    elsif params[:filter].present? && params[:filter] == 'free'
      @movies = Movie.except_body_with_default.where(is_original: true, is_paid: false).order('id DESC').page(params[:page]).per(20)
    elsif params[:filter].present? && params[:filter] == 'pro'
      @movies = Movie.except_body_with_default.where(is_original: true, is_paid: true).order('id DESC').page(params[:page]).per(20)
    else
      @movies = Movie.except_body_with_default.where(is_original: true).order('id DESC').page(params[:page]).per(20)
    end

    @serials = Rails.cache.fetch('serials') do
      Serial.order(weight: :desc).to_a
    end

    @title = 'web 编程视频'

    ahoy.track @title, {language: "Ruby"}

    # respond_to do |format|
    #   format.all { render :index, formats: [:html] }
    # end
  end

  def show
    ahoy.track @movie.title, {language: "Ruby"}
    @title = @movie.title

    # @recommend_movies = @movie.recommend_movies
    @playlist_movies = @movie.playlist_movies

    @comments = @movie.fetch_comments
    @comment = @movie.comments.build

    # @site_info_home_desc = Playlist.fetch_by_id(@movie.playlist_id).try(:desc)

    if !(current_user && current_user.super_admin?)
      @movie.increment_read_count
    end

    # 热门播放列表
    @playlists = Rails.cache.fetch 'article_playlists' do
      Playlist.where(is_original: true).order(weight: :desc).limit(4).to_a
    end

    @prev_movie = @movie.playlist.movies.where("weight < ?", @movie.weight).first
    @next_movie = @movie.playlist.movies.where("weight > ?", @movie.weight).last

    if user_signed_in? && !current_user.super_admin?
      $redis.lpush "movies_#{current_user.id}_history", @movie.id
      $redis.ltrim "movies_#{current_user.id}_history", 0, 99

      Redis.new.publish 'ws', { only_website: true, title: '努力学习', content: "学员 <strong class='heart-green'>#{current_user.hello_name}</strong> 正在学习 #{@movie.title}" }.to_json

      SendSystemHistory.send_system_history("学员 <a href=#{movie_history_user_path(current_user)}>#{current_user.hello_name}</a>", "正在学习", "<a href=#{movie_path(@movie)}>#{@movie.title}</a>")
    else
      return if user_signed_in? && current_user.super_admin?

      Redis.new.publish 'ws', { only_website: true, title: '努力学习', content: "游客 正在学习 #{@movie.title}" }.to_json

      SendSystemHistory.send_system_history("游客", "正在学习", "<a href=#{movie_path(@movie)}>#{@movie.title}</a>")
    end
  end

  def new
    @movie = Movie.new
  end

  def edit
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      @movie.create_activity :create, owner: current_user
      flash[:success] = "创建成功"
      redirect_to movie_path(@movie)
    else
      render :new
    end
  end

  def update
    if @movie.update(movie_params)
      Redis.new.publish 'ws', { title: 'rails365 更新了视频', content: @movie.title, url: "https://www.rails365.net/movies/#{@movie.slug}" }.to_json
      flash[:success] = "更新成功"
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie.destroy
    @movie.create_activity :destroy, owner: current_user
    redirect_to movies_path, notice: '视频成功删除!'
  end

  def like
    current_user.toggle_like(@movie)
    @movie.update_like_count
    if @movie.liked_by?(current_user)
      unless current_user.super_admin?
        @movie.create_activity key: 'movie.like', owner: current_user
        Redis.new.publish 'ws', { only_website: true, title: '获得喜欢', content: "学员 <strong class='heart-green'>#{current_user.hello_name}</strong> 喜欢了 #{@movie.title}" }.to_json
        SendSystemHistory.send_system_history("学员 <a href=#{movie_history_user_path(current_user)}>#{current_user.hello_name}</a>", "喜欢", "<a href=#{movie_path(@movie)}>#{@movie.title}</a>")
      end
    end
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
      params.require(:movie).permit(:title, :is_paid, :mp4_name, :author, :play_time, :body, :playlist_id, :user_id, :image, :mp4_url, :youtube_url, :is_finished, :download_url)
    end
  end
end
