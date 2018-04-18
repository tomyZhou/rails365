class AddWeightToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :weight, :integer, default: 0
  end
end
