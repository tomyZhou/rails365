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
end
