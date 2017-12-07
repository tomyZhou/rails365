class AddLikeCountToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :like_count, :integer, default: 0
  end
end
