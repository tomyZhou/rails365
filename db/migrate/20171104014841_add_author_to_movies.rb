class AddAuthorToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :author, :string
  end
end
