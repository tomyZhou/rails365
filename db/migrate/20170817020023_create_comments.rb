class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :article, index: true
      t.belongs_to :user, index: true
      t.belongs_to :commentable, polymorphic: true, index: true
      t.text :body

      t.timestamps null: false
    end
  end
end
