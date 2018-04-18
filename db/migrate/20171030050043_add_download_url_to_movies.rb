class AddDownloadUrlToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :download_url, :text
  end
end
