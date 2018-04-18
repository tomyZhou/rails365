class AddIsFinishedToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :is_finished, :boolean, default: true
  end
end
