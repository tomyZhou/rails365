class RemoveMetaDescriptionFromArticles < ActiveRecord::Migration
  def up
    remove_column :articles, :meta_description
  end

  def down
    add_column :articles, :meta_description, :string
  end
end
