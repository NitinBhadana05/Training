class AddIndexesToTables < ActiveRecord::Migration[8.1]
  def change
    add_index :users, :email, unique: true
    add_index :books, :isbn, unique: true
    add_index :copies, :barcode, unique: true

    execute <<-SQL
      ALTER TABLE borrows
      ADD CONSTRAINT valid_dates CHECK (due_at >= issued_at);
    SQL
  end
end
