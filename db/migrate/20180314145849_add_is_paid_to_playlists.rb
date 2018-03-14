class AddIsPaidToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :is_paid, :boolean, default: false
  end
end
