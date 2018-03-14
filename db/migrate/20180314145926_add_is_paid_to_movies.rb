class AddIsPaidToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :is_paid, :boolean, default: false
  end
end
