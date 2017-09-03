class AddIsHomeToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :is_home, :boolean, default: false
  end
end
