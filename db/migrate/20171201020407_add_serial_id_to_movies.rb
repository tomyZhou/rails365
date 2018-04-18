class AddSerialIdToMovies < ActiveRecord::Migration[5.2]
  def change
    add_reference :movies, :serial, index: true
  end
end
