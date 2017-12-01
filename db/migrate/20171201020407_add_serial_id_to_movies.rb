class AddSerialIdToMovies < ActiveRecord::Migration
  def change
    add_reference :movies, :serial, index: true
  end
end
