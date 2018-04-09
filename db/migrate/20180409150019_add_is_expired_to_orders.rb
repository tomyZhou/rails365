class AddIsExpiredToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :is_expired, :boolean, default: false
  end
end
