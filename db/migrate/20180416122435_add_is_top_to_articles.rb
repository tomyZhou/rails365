class AddIsTopToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :is_top, :boolean, default: false
  end
end
