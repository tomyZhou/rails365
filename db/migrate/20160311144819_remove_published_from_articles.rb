class RemovePublishedFromArticles < ActiveRecord::Migration[5.2]
  def up
    remove_column :articles, :published
  end

  def down
    add_column :articles, :published, :boolean, default: false
  end
end
