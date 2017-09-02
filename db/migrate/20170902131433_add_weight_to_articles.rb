class AddWeightToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :weight, :integer, default: 0
  end
end
