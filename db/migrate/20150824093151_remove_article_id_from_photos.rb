class RemoveArticleIdFromPhotos < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :article_id
  end
end
