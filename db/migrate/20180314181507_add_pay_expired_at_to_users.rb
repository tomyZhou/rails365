class AddPayExpiredAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pay_expired_at, :datetime
  end
end
