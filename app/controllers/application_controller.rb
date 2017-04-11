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
    @sites = Admin::Site.cached_all

    @site_info_name = Admin::SiteInfo.fetch_by_key('name').try(:value)
    @site_info_title = Admin::SiteInfo.fetch_by_key('title').try(:value)
    @site_info_meta_description = Admin::SiteInfo.fetch_by_key('meta_description').try(:value)
    @site_info_meta_keyword = Admin::SiteInfo.fetch_by_key('meta_keyword').try(:value)

    # if current_user && current_user.super_admin?
    Rack::MiniProfiler.authorize_request
    # end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to '/'
  end

  private
  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
    # request.user_agent =~ /Mobile|Blackberry|Android/ # OR WHATEVER
  end
  helper_method :mobile_device?
end
