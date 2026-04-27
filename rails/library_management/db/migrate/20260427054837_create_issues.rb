class CreateIssues < ActiveRecord::Migration[8.1]
  def change
    create_table :issues do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :transaction_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.date :issue_date, null: false
      t.date :due_date
      t.date :return_date
      t.decimal :rent_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :late_fine, precision: 10, scale: 2, null: false, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :issues, :status
  end
end
