class Admin::SidekiqExceptionsController < Admin::BaseController
  before_action :set_sidekiq_exception, only: [:show, :destroy]

  def index
    @sidekiq_exceptions = Admin::SidekiqException.order("id DESC").page(params[:page]).per(20)
  end

  def show
  end

  def destroy
    @sidekiq_exception.destroy
    respond_to do |format|
      format.html { redirect_to admin_sidekiq_exceptions_url, notice: 'Sidekiq Exception was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    if params[:clear_all].present?
      Admin::SidekiqException.delete_all
    else
      Admin::SidekiqException.delete(params[:sidekiq_exception_ids])
    end
    flash[:danger] = '删除成功'
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sidekiq_exception
      @sidekiq_exception = Admin::SidekiqException.find(params[:id])
    end
end
