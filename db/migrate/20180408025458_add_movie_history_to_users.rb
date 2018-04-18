class AddMovieHistoryToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :movie_history, :integer, array: true
    add_index :users, :movie_history, using: 'gin'
  end
end
