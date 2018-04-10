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
    @new_users = Rails.cache.fetch "new_users" do
      User.order(id: :desc).limit(5).to_a
    end

    # 活跃用户
    @active_weight_users = Rails.cache.fetch "active_weight_users" do
      User.order(active_weight: :desc, id: :desc).limit(5)
    end

    # 热门播放列表
    @playlists = Rails.cache.fetch 'article_playlists' do
      Playlist.where(is_original: true).order(weight: :desc).limit(4).to_a
    end
  end
end
