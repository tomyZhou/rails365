class RemoveMetaDescriptionFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :meta_description
  end
end
