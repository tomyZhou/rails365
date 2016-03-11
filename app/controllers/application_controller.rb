class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_sites
  before_action :authorize

  private
    def set_sites
      @sites = Rails.cache.fetch("sites") do
        Site.all.to_a
      end
      @site_info_name = Rails.cache.fetch "site_info_name" do
        Admin::SiteInfo.find_by(key: "name").try(:value)
      end
      @site_info_title = Rails.cache.fetch "site_info_title" do
        Admin::SiteInfo.find_by(key: "title").try(:value)
      end
      @site_info_meta_description = Rails.cache.fetch "site_info_meta_description" do
        Admin::SiteInfo.find_by(key: "meta_description").try(:value)
      end
      @site_info_meta_keyword = Rails.cache.fetch "site_info_meta_keyword" do
        Admin::SiteInfo.find_by(key: "meta_keyword").try(:value)
      end
    end
    def authorize
      if session[:admin]
        Rack::MiniProfiler.authorize_request
      end
    end
end
