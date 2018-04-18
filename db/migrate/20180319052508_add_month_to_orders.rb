class AddMonthToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :month, :integer, default: 1
  end
end
