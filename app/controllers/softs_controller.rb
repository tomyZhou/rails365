class SoftsController < ApplicationController
  before_action :set_soft, only: [:show]
  before_action :find_changed_soft, only: [:edit, :update, :destroy, :like]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :like]
  authorize_resource

  def index
    if params[:search].present?
      @softs = Soft.search params[:search], fields: [:title, :body, :name, :tag], page: params[:page], per_page: 20
    else
      @softs = Soft.except_body_with_default.order('id DESC').page(params[:page]).per(20)
    end

    @title = '下载列表'

    # respond_to do |format|
    #   format.all { render :index, formats: [:html] }
    # end
  end

  def show
    @title = @soft.title

    @comments = @soft.fetch_comments
    @comment = @soft.comments.build
    @soft.increment_read_count
  end

  def new
    @soft = Soft.new
  end

  def edit
  end

  def create
    @soft = Soft.new(soft_params)

    if @soft.save
      flash[:success] = "创建成功"
      redirect_to soft_path(@soft)
    else
      render :new
    end
  end

  def update
    if @soft.update(soft_params)
      # Redis.new.publish 'ws', { title: 'rails365 更新了资源', content: @soft.title }.to_json
      flash[:success] = "更新成功"
      redirect_to soft_path(@soft)
    else
      render :edit
    end
  end

  def destroy
    @soft.destroy
    redirect_to softs_path, notice: '成功删除!'
  end

  def like
    current_user.toggle_like(@soft)
    @soft.update_like_count
  end

  private

  def set_soft
    @soft = Soft.fetch_by_slug!(params[:id])
  rescue ActiveRecord::RecordNotFound
    @soft = Soft.find(params[:id])
  end

  def find_changed_soft
    @soft = Soft.find(params[:id])
  end

  def soft_params
    params.require(:soft).permit!
  end
end
