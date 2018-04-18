class AddWeightToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :weight, :integer, default: 0
  end
end
