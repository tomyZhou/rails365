class AddLikeCountToSofts < ActiveRecord::Migration
  def change
    add_column :softs, :like_count, :integer, default: 0
  end
end
