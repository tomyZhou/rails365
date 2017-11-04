class AddAuthorToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :author, :string
  end
end
