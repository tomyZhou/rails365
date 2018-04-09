class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show]
  after_action :set_ahoy_track, only: [:show, :index]
  authorize_resource

  def index
    @playlists = Rails.cache.fetch 'playlist_all' do
      Playlist.where(is_original: true).order(weight: :desc).to_a
    end

    if params[:q].presence == 'all'
      @playlists = Playlist.order(weight: :desc)
    end

    @title = "播放列表"
  end

  def show
    @title = @playlist.name
  end

  private

  def set_ahoy_track
    ahoy.track @title, {language: "Ruby"}
  end

  def set_playlist
    @playlist = Playlist.fetch_by_slug!(params[:id])
    if params[:q].present?
      if params[:q] == 'free'
        @movies = @playlist.movies.where(is_paid: false).reorder(weight: :asc)
      elsif params[:q] == 'pro'
        @movies = @playlist.movies.where(is_paid: true).reorder(weight: :asc)
      end
    else
      @movies = @playlist.fetch_movies
    end
  end
end
