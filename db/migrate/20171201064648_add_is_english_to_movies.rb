class AddIsEnglishToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :is_english, :boolean, default: false
  end
end
