class HomeController < ApplicationController
  def index
    @articles = Rails.cache.fetch 'articles' do
      Article.except_body_with_default.order('updated_at DESC').limit(10).to_a
    end

    @hot_articles = Rails.cache.fetch 'hot_articles' do
      Article.except_body_with_default.where(is_home: true).limit(10).to_a
    end

    @groups = Rails.cache.fetch('groups', expires_in: 2.hours) do
      Group.order(weight: :desc).limit(Group.count - (Group.count % 6)).to_a
    end

    @playlists = Rails.cache.fetch('playlists') do
      Playlist.order(weight: :desc).limit(Playlist.count - (Playlist.count % 5)).to_a
    end

    @movies = Rails.cache.fetch('movies') do
      Movie.except_body_with_default.order(updated_at: :desc).limit(20).to_a
    end

    @books = Rails.cache.fetch('books') do
      Book.order(weight: :desc).limit(Book.count - (Book.count % 2)).to_a
    end

    respond_to do |format|
      format.all { render :index, formats: [:html] }
    end
  end

  def find
    if params[:tp] == "movies"
      redirect_to movies_path(tp: 'movies', search: params[:search])
    elsif params[:tp] == "softs"
      redirect_to softs_path(tp: 'softs', search: params[:search])
    else
      redirect_to articles_path(tp: 'articles', search: params[:search])
    end
  end
end
