class BooksController < ApplicationController
  authorize_resource
  def index
    @books = Rails.cache.fetch :book_all do
      Book.order(weight: :desc).to_a
    end
    @title = "小书列表"
  end
end
