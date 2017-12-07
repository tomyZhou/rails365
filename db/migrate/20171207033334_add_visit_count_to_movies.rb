class AddVisitCountToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :visit_count, :integer, default: 0
  end
end
