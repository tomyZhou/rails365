class AddIsFinishedToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :is_finished, :boolean, default: false
  end
end
