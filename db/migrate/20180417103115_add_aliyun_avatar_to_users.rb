class AddAliyunAvatarToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :small_aliyun_avatar, :string
    add_column :users, :big_aliyun_avatar, :string
  end
end
