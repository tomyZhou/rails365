class AppsController < ApplicationController
  authorize_resource

  def index
    @apps = Rails.cache.fetch "app_all" do
      App.all.to_a
    end
    @title = "演示应用列表"
  end
end
