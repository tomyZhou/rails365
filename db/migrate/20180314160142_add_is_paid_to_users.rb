class AddIsPaidToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_paid, :boolean, default: false
  end
end
