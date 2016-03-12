class Admin::SitesController < Admin::BaseController
  before_action :set_site, only: [:edit, :update, :destroy]

  def index
    @sites = Admin::Site.all
  end

  def new
    @site = Admin::Site.new
  end

  def edit
  end

  def create
    @site = Admin::Site.new(site_params)
    respond_to do |format|
      if @site.save
        expired_common
        format.html { redirect_to admin_sites_path, notice: 'Site was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @site.update(site_params)
        expired_common
        format.html { redirect_to admin_sites_path, notice: 'Site was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @site.destroy
    expired_common
    respond_to do |format|
      format.html { redirect_to admin_sites_url, notice: 'Site was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_site
      @site = Admin::Site.find(params[:id])
    end

    def site_params
      params.require(:admin_site).permit(:name, :url)
    end

    def expired_common
      Rails.cache.delete "sites"
    end
end
