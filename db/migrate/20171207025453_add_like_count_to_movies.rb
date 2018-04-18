class AddLikeCountToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :like_count, :integer, default: 0
  end
end
