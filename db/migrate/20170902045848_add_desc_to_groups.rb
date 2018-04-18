class AddDescToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :desc, :text
  end
end
