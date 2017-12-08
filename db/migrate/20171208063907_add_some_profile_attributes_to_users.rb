class AddSomeProfileAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string
    add_column :users, :github, :string
    add_column :users, :twitter, :string
    add_column :users, :company_name, :string
    add_column :users, :position, :string
  end
end
