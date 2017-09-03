class AddWeightToBooks < ActiveRecord::Migration
  def change
    add_column :books, :weight, :integer, default: 0
  end
end
