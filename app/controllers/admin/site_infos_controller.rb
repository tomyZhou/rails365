class Admin::SiteInfosController < Admin::BaseController
  before_action :set_site_info, only: [:edit, :update]
  load_and_authorize_resource

  def index
    @site_infos = Admin::SiteInfo.all
  end

  def edit
  end

  def update
    respond_to do |format|
      if @site_info.update(site_info_params)
        Rails.cache.delete "site_info_#{@site_info.key}"
        format.html { redirect_to admin_site_infos_path, notice: 'Site_info was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    def set_site_info
      @site_info = Admin::SiteInfo.find(params[:id])
    end

    def site_info_params
      params.require(:admin_site_info).permit(:value)
    end

end
