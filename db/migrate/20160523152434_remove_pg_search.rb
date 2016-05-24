class RemovePgSearch < ActiveRecord::Migration
  def up
    execute("DROP INDEX articles_idx;")
  end

  def down
    execute("CREATE INDEX articles_idx ON articles USING gin(to_tsvector('testzhcfg', title || ' ' || body));")
  end
end
