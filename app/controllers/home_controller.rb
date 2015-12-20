class HomeController < ApplicationController
  def index
    @articles = Rails.cache.fetch "articles" do
      Article.except_body_with_default.order("id DESC").limit(10).to_a
    end
    @hot_articles = Rails.cache.fetch "hot_articles" do
      Article.except_body_with_default.select("visit_count").order("visit_count DESC").limit(10).to_a
    end
    @groups = Rails.cache.fetch("groups", expires_in: 2.hours) do
      Group.all.to_a
    end
    @sites = Rails.cache.fetch("sites") do
      Site.all.to_a
    end
  end
end
