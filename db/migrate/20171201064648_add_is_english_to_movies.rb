class AddIsEnglishToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :is_english, :boolean, default: false
  end
end
