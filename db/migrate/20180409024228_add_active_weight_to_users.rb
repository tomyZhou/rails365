class AddActiveWeightToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :active_weight, :integer, default: 0
  end
end
