class GroupsController < ApplicationController
  before_action :set_group, only: [:show]
  authorize_resource

  def index
    @groups = Cache.group_all
    @title = "分类列表"
  end

  def show
    @title = @group.name

    @users = User.where(id: Article.pluck(:user_id).uniq)

    @books = @group.fetch_books

    @groups = Cache.group_all
  end

  private

  def set_group
    @group = Group.fetch_by_slug!(params[:id])
    @articles = @group.fetch_articles
  end
end
