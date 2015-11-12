class Admin::BaseController < ActionController::Base
  REALM = ENV["REALM"]
  USERS = {ENV["USERNAME"] => ENV['PASSWORD'],
           "dap" => Digest::MD5.hexdigest(["dap", REALM, "secret"].join(":"))}
  layout "admin"

  before_action :authenticate
  before_action :authorize

  private
    def authenticate
      authenticate_or_request_with_http_digest(REALM) do |username|
        session[:admin] = true
        USERS[username]
      end
    end

    def authorize
      if session[:admin]
        Rack::MiniProfiler.authorize_request
      end
    end
end
