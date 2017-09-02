class ChangeAdminSitesValueType < ActiveRecord::Migration
  def change
    change_column :admin_site_infos, :value, :text
  end
end
