class CreateBorrows < ActiveRecord::Migration[8.1]
  def change
    create_table :borrows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :copy, null: false, foreign_key: true
      t.datetime :issued_at
      t.datetime :due_at
      t.datetime :returned_at
      t.decimal :fine
      t.string :status

      t.timestamps
    end
  end
end
