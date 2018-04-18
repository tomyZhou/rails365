class AddIsPaidToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :is_paid, :boolean, default: false
  end
end
