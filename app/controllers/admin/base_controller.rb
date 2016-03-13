class Admin::BaseController < ActionController::Base
  layout "admin"

  before_action do
    @site_info_name = Rails.cache.fetch "site_info_name" do
      Admin::SiteInfo.find_by(key: "name").try(:value)
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
