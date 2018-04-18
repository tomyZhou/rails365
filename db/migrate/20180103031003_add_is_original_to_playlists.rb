class AddIsOriginalToPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :playlists, :is_original, :boolean, default: false
  end
end
