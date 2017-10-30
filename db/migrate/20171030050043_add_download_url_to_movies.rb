class AddDownloadUrlToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :download_url, :text
  end
end
