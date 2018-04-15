class PhotosController < ApplicationController
  before_action :authenticate_user!
  def create
    @photo = Photo.new
    @photo.image = params[:image]
    @photo.save
    render text: @photo.image_url.to_s
  end
end
