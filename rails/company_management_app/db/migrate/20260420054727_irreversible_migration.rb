class IrreversibleMigration < ActiveRecord::Migration[8.1]
  def up
    drop_table :pratices

  end

  def down
    raise ActiveRecord::IrreversibleMigration,"Cannot revert this migration"
  end

end
