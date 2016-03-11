class Admin::ExceptionLogsController < Admin::BaseController
  before_action :set_exception_log, only: [:show, :destroy]

  def index
    @exception_logs = Admin::ExceptionLog.order("id DESC").page(params[:page]).per(20)
  end

  def show
  end

  def destroy
    @exception_log.destroy
    respond_to do |format|
      format.html { redirect_to admin_exception_logs_url, notice: 'Exception log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    if params[:clear_all].present?
      Admin::ExceptionLog.delete_all
    else
      Admin::ExceptionLog.delete(params[:exception_log_ids])
    end
    flash[:danger] = '删除成功'
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exception_log
      @exception_log = Admin::ExceptionLog.find(params[:id])
    end
end
