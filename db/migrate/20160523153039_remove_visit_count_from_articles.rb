class RemoveVisitCountFromArticles < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :visit_count
  end
end
