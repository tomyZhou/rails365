class AddIsOriginalToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :is_original, :boolean, default: false
  end
end
