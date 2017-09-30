class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name
      t.string :image
      t.string :slug
      t.text :desc
      t.integer :weight, default: 0
      t.integer :movies_count, default: 0

      t.timestamps null: false
    end
    add_index :playlists, :slug, unique: true
  end
end
