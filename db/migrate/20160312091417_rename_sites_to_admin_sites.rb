class RenameSitesToAdminSites < ActiveRecord::Migration
  def change
    rename_table :sites, :admin_sites
  end
end
