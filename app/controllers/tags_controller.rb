class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.order("taggings_count DESC")
    set_meta_tags title: "分类列表", description: ENV["meta_description"], keywords: @tags.map(&:name).join(", ")
  end
end
