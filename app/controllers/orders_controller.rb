class OrdersController < ApplicationController
  authorize_resource
  before_action :authenticate_user!

  def index
    if current_user.super_admin?
      @orders = Order.order(created_at: :desc)
    else
      @orders = current_user.orders
    end
    @title = "我的订单"
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save && @order.make_order_and_user_paid
      flash[:success] = '创建成功'
      redirect_to orders_path
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:month, :money, :user_id)
  end
end
