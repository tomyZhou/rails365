class AddActiveWeightToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_weight, :integer, default: 0
  end
end
