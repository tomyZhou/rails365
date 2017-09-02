class HomeController < ApplicationController
  def index
    @articles = Rails.cache.fetch 'articles' do
      Article.except_body_with_default.order('id DESC').limit(10).to_a
    end

    @hot_articles = Rails.cache.fetch 'hot_articles' do
      Article.except_body_with_default.order(weight: :desc).limit(10).to_a
    end

    @groups = Rails.cache.fetch('groups', expires_in: 2.hours) do
      Group.all
    end

    @books = Rails.cache.fetch('books') do
      Book.all
    end

    respond_to do |format|
      format.all { render :index, formats: [:html] }
    end
  end
end
