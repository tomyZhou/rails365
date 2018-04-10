class ActivitiesController < ApplicationController
  def index
    authorize! :manage, PublicActivity::Activity
    @activities = PublicActivity::Activity.order(id: :desc).page(params[:page]).per(25)
  end

  def destroy_multiple
    authorize! :manage, PublicActivity::Activity
    PublicActivity::Activity.delete(params[:activity_ids])
    flash[:success] = '删除成功'
    redirect_to :back
  end

  def destroy
    authorize! :manage, PublicActivity::Activity
    @activity = PublicActivity::Activity.find(params[:id])
    @activity.destroy
    flash[:success] = '删除成功'
    redirect_to :back
  end
end
