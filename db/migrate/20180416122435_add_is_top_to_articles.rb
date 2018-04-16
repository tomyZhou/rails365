class AddIsTopToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :is_top, :boolean, default: false
  end
end
