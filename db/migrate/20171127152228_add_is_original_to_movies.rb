class AddIsOriginalToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :is_original, :boolean, default: false
  end
end
