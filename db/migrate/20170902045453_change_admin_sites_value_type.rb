class ChangeAdminSitesValueType < ActiveRecord::Migration[5.2]
  def change
    change_column :admin_site_infos, :value, :text
  end
end
