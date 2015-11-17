class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.order("taggings_count DESC")
    set_meta_tags title: "标签列表", description: ENV["meta_description"], keywords: ENV["meta_keyword"]
  end
end
