class AddWeightToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :weight, :integer, default: 0
  end
end
