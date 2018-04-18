class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :link_url
      t.string :image
      t.string :slug

      t.timestamps null: false
    end
  end
end
