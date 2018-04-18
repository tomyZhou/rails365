class AddVisitCountToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :visit_count, :integer, default: 0
  end
end
