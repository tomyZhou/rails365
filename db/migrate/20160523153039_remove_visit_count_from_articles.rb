class RemoveVisitCountFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :visit_count
  end
end
