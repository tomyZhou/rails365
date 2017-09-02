class AddDescToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :desc, :text
  end
end
