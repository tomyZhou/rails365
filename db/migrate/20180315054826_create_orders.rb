class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true
      t.datetime :expired_at
      t.decimal :money, precision: 10, scale: 2

      t.timestamps null: false
    end
  end
end
