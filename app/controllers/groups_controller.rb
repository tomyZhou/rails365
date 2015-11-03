class GroupsController < ApplicationController
  before_action :set_group, only: [:show]

  def index
    @groups = Rails.cache.fetch "group_all" do
      Group.all.to_a
    end
    set_meta_tags title: "分类列表", description: "提供rails文章和视频教程，知识和信息交流", keywords: @groups.map(&:name).join(", ")
  end

  def show
    @keywords = Rails.cache.fetch "group:#{@group.id}/tag_list" do
      @group.articles.map(&:tag_list).join(", ").split(", ").uniq.to_a
    end
    set_meta_tags title: @group.name, description: @group.name, keywords: @keywords
  end

  private
    def set_group
      @group = Rails.cache.fetch "group:#{params[:id]}" do
        Group.find(params[:id])
      end
      @articles = Rails.cache.fetch "group:#{@group.id}/articles" do
        @group.articles.published.to_a
      end
    end
end
