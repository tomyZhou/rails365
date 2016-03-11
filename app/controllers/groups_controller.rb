class GroupsController < ApplicationController
  before_action :set_group, only: [:show]

  def index
    @groups = Rails.cache.fetch "group_all" do
      Group.all.to_a
    end
    @title = "分类列表"
  end

  def show
    @title = @group.name
  end

  private
    def set_group
      @group = Rails.cache.fetch "group:#{params[:id]}" do
        Group.find(params[:id])
      end
      @articles = Rails.cache.fetch "group:#{@group.id}/articles" do
        @group.articles.to_a
      end
    end
end
