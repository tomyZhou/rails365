class GroupsController < ApplicationController
  before_action :set_group, only: [:show]
  authorize_resource

  def index
    @groups = Rails.cache.fetch 'group_all' do
      Group.all.to_a
    end
    @title = "分类列表"
  end

  def show
    @title = @group.name

    @site_info_home_desc = @group.desc
  end

  private

  def set_group
    @group = Group.fetch_by_slug!(params[:id])
    @articles = @group.fetch_articles
  end
end
