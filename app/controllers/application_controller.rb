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
    end
    def authorize
      if session[:admin]
        Rack::MiniProfiler.authorize_request
      end
    end
end
