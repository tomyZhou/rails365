class HomeController < ApplicationController
  def index
    @articles = Rails.cache.fetch 'articles' do
      Article.except_body_with_default.order('id DESC').limit(10).to_a
    end

    @hot_articles = Rails.cache.fetch 'hot_articles' do
      Article.except_body_with_default.where(is_home: true).limit(10).to_a
    end

    @groups = Rails.cache.fetch('groups', expires_in: 2.hours) do
      Group.order(weight: :desc).to_a
    end

    @movies = Rails.cache.fetch('movies') do
      Movie.order(weight: :desc).to_a
    end

    @books = Rails.cache.fetch('books') do
      Book.order(weight: :desc).to_a
    end

    respond_to do |format|
      format.all { render :index, formats: [:html] }
    end
  end
end
