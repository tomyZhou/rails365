class AddPayExpiredAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pay_expired_at, :datetime
  end
end
