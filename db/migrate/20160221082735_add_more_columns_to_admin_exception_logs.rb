class AddMoreColumnsToAdminExceptionLogs < ActiveRecord::Migration
  def change
    add_column :admin_exception_logs, :request_url, :string
    add_column :admin_exception_logs, :message, :text
  end
end
