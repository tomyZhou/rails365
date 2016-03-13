class AddUserIdToArticles < ActiveRecord::Migration
  def change
    add_reference :articles, :user, index: true, foreign_key: true
  end

  def data
    user = User.create! email: "hfpp2012@aliyun.com", password: "12345678", login: "hfpp2012"
    Article.update_all user_id: user.id
  end

  def rollback
    User.find_by(email: "hfpp2012@aliyun.com").destroy
    Article.update_all user_id: nil
  end
end
