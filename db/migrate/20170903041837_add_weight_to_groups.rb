class AddWeightToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :weight, :integer, default: 0
  end
end
