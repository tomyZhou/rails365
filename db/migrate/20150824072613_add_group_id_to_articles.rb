class AddGroupIdToArticles < ActiveRecord::Migration[5.2]
  def change
    add_reference :articles, :group, index: true, foreign_key: true
  end
end
