class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  before_action do

    @sites = Rails.cache.fetch("sites") do
      Admin::Site.all.to_a
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

    if current_user && current_user.super_admin?
      Rack::MiniProfiler.authorize_request
    end

  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_url
  end

end
