class Admin::BaseController < ActionController::Base
  protect_from_forgery with: :exception

  layout "admin"

  before_action do
    @site_info_name = Admin::SiteInfo.fetch_by_uniq_keys(key: "name").try(:value)

    if current_user && current_user.super_admin?
      Rack::MiniProfiler.authorize_request
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_url
  end

end
