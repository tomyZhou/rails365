class AddIsExpiredToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :is_expired, :boolean, default: false
  end
end
