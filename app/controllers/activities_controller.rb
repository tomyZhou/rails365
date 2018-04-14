class ActivitiesController < ApplicationController
  def index
    authorize! :manage, PublicActivity::Activity
    @activities = PublicActivity::Activity.order(created_at: :desc).page(params[:page]).per(25)
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

  def explore
    @activities = PublicActivity::Activity.order(created_at: :desc).page(params[:page])

    # 新用户
    @new_users = Cache.new_users

    # 活跃用户
    @active_weight_users = Cache.active_weight_users

    # 热门播放列表
    @playlists = Cache.article_playlists

    @movies = Cache.movies(3)

    @articles = Cache.new_articles
  end
end
