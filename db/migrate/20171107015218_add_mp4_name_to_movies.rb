class AddMp4NameToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :mp4_name, :string
  end
end
