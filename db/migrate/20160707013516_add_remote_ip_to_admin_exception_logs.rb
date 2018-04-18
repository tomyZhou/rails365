class AddRemoteIpToAdminExceptionLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_exception_logs, :remote_ip, :string
  end
end
