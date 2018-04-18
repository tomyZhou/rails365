class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.string :image
      t.belongs_to :article, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
