class CreateSerials < ActiveRecord::Migration[5.2]
  def change
    create_table :serials do |t|
      t.string :name
      t.string :slug
      t.integer :weight, default: 0
      t.integer :movies_count, default: 0

      t.timestamps null: false
    end
    add_index :serials, :slug, unique: true
  end
end
