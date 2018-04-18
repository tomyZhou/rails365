class CreateSofts < ActiveRecord::Migration[5.2]
  def change
    create_table :softs do |t|
      t.string :title
      t.text :body
      t.string :image
      t.string :name
      t.string :slug
      t.string :download_url
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
    add_index :softs, :slug, unique: true
  end
end
