class AddLikeCountToSofts < ActiveRecord::Migration[5.2]
  def change
    add_column :softs, :like_count, :integer, default: 0
  end
end
