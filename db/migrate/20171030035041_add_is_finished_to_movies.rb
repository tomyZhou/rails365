class AddIsFinishedToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :is_finished, :boolean, default: true
  end
end
