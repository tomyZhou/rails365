class GroupsController < ApplicationController
  before_action :set_group, only: [:show]
  before_action :find_changed_group, only: [:edit, :update, :destroy]
  authorize_resource

  def index
    @groups = Rails.cache.fetch "group_all" do
      Group.all.to_a
    end
    @title = "分类列表"
  end

  def show
    @title = @group.name
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    def set_group
      @group = Group.fetch_by_uniq_keys!(slug: params[:id])
      @articles = @group.cached_articles
    end

    def find_changed_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :image)
    end

end
