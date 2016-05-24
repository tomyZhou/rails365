class CreateAdminSidekiqExceptions < ActiveRecord::Migration
  def change
    create_table :admin_sidekiq_exceptions do |t|
      t.string :ex
      t.text :ctx_hash

      t.timestamps null: false
    end
  end
end
