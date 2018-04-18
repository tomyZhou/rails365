class RenameSitesToAdminSites < ActiveRecord::Migration[5.2]
  def change
    rename_table :sites, :admin_sites
  end
end
