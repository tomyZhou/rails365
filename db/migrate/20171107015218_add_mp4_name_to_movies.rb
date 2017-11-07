class AddMp4NameToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :mp4_name, :string
  end
end
