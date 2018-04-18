class AddIsHomeToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :is_home, :boolean, default: false
  end
end
