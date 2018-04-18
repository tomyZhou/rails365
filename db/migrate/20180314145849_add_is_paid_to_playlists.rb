class AddIsPaidToPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :playlists, :is_paid, :boolean, default: false
  end
end
