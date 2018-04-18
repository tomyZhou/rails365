class AddVisitCountToSofts < ActiveRecord::Migration[5.2]
  def change
    add_column :softs, :visit_count, :integer, default: 0
  end
end
