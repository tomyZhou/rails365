class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]
  before_action :find_changed_movie, only: [:edit, :update, :destroy, :like]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :like]
  authorize_resource

  def index
    if params[:search].present?
      @movies = Movie.search params[:search], where: { is_original: true }, boost_by: [:visit_count], fields: [:title, :body], includes: [:playlist], track: { user_id: current_user.try(:id) }, page: params[:page], per_page: 20
    elsif params[:name].present?
      @serial = Serial.find(params[:name])
      @movies = @serial.movies.where(is_original: true).order('id DESC').page(params[:page]).per(20)
    elsif params[:filter].present? && params[:filter] == 'original'
      @movies = Movie.order('id DESC').page(params[:page]).per(20)
    elsif params[:filter].present? && params[:filter] == 'other'
      @movies = Movie.where(is_original: true).where("serial_id is null").order('id DESC').page(params[:page]).per(20)
    elsif params[:filter].present? && params[:filter] == 'free'
      @movies = Movie.where(is_original: true, is_paid: false).order('id DESC').page(params[:page]).per(20)
    elsif params[:filter].present? && params[:filter] == 'pro'
      @movies = Movie.where(is_original: true, is_paid: true).order('id DESC').page(params[:page]).per(20)
    else
      @movies = Movie.where(is_original: true).order('id DESC').page(params[:page]).per(20)
    end

    @serials = Rails.cache.fetch("serials") do
      Serial.order(weight: :desc).to_a
    end

    @title = '视频列表'

    # respond_to do |format|
    #   format.all { render :index, formats: [:html] }
    # end
  end

  def show
    @title = @movie.title

    # @recommend_movies = @movie.recommend_movies
    @playlist_movies = @movie.playlist_movies

    if @movie.has_read_priv?(current_user)
      @comments = @movie.fetch_comments
      @comment = @movie.comments.build

      @prev_movie = @movie.prev_movie
      @next_movie = @movie.next_movie
    end

    @recommend_movies = @movie.recommend_movies

    # @site_info_home_desc = Playlist.fetch_by_id(@movie.playlist_id).try(:desc)

    if !(current_user && current_user.super_admin?)
      @movie.increment_read_count

      # 记录哪些视频被浏览过
      @movie.remember_visit_id
    end

    @playlists = Cache.article_playlists

    @movie.login_visit_history(current_user)
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

      # ActionCable.server.broadcast \
      #   "notification_channel", { title: 'rails365 更新了视频',
      #                             content: @movie.title,
      #                             url: "https://www.rails365.net/movies/#{@movie.slug}"
      # }.to_json

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

    if @movie.liked_by?(current_user) && !current_user.super_admin?

      @movie.create_activity key: 'movie.like', owner: current_user

      ActionCable.server.broadcast \
        'web_channel', { title: '获得喜欢', content: "学员 <strong>#{current_user.hello_name}</strong> 喜欢了 #{@movie.title}" }.to_json

      SendSystemHistory.send_system_history("学员 <a href=#{movie_history_user_path(current_user)}>#{current_user.hello_name}</a>", "喜欢", "<a href=#{movie_path(@movie)}>#{@movie.title}</a>")
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
