class DropHomeland < ActiveRecord::Migration
  def change
    drop_table :homeland_nodes
    drop_table :homeland_topics
    drop_table :homeland_replies
  end
end
