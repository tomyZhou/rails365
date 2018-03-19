class AddMonthToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :month, :integer, default: 1
  end
end
