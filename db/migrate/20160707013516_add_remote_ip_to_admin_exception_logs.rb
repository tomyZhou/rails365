class AddRemoteIpToAdminExceptionLogs < ActiveRecord::Migration
  def change
    add_column :admin_exception_logs, :remote_ip, :string
  end
end
