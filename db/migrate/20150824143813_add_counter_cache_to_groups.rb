class AddCounterCacheToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :articles_count, :integer, default: 0
  end
end
