class AddTagToSofts < ActiveRecord::Migration
  def change
    add_column :softs, :tag, :string
  end
end
