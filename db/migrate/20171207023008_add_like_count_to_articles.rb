class AddLikeCountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :like_count, :integer, default: 0
  end
end
