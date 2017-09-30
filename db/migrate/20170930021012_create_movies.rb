class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :body
      t.string :slug
      t.string :image
      t.string :mp4_url
      t.integer :weight, default: 0
      t.belongs_to :user, index: true
      t.belongs_to :playlist, index: true

      t.timestamps null: false
    end
    add_index :movies, :slug, unique: true
  end
end
