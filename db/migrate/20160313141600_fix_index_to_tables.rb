class FixIndexToTables < ActiveRecord::Migration[5.2]
  def change
    change_column :articles, :title, :string, null: false, default: ""
    add_index :articles, :title, unique: true

    change_column :groups, :name, :string, null: false, default: ""
    add_index :groups, :name, unique: true

    change_column :admin_sites, :name, :string, null: false, default: ""
    add_index :admin_sites, :name, unique: true

    change_column :admin_site_infos, :key, :string, null: false, default: ""
    add_index :admin_site_infos, :key, unique: true
  end
end
