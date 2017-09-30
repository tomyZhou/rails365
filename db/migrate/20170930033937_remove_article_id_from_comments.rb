class RemoveArticleIdFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :article_id, :string
  end
end
