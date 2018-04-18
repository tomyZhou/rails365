class AddTagToSofts < ActiveRecord::Migration[5.2]
  def change
    add_column :softs, :tag, :string
  end
end
