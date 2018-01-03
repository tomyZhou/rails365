class AddIsOriginalToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :is_original, :boolean, default: false
  end
end
