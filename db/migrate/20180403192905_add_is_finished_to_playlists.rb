class AddIsFinishedToPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :playlists, :is_finished, :boolean, default: false
  end
end
