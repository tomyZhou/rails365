class AddUsernameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
  end

  def data
    user = User.create! email: "hfpp2012@aliyun.com", password: "12345678", username: "hfpp2012"
    Article.update_all user_id: user.id
  end

  def rollback
    User.find_by(email: "hfpp2012@aliyun.com").destroy
    Article.update_all user_id: nil
  end
end
