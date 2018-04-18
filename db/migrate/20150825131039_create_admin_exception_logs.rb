class CreateAdminExceptionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_exception_logs do |t|
      t.string :title
      t.text :body

      t.timestamps null: false
    end
  end
end
