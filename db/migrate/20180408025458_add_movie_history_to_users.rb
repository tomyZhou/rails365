class AddMovieHistoryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :movie_history, :integer, array: true
    add_index :users, :movie_history, using: 'gin'
  end
end
