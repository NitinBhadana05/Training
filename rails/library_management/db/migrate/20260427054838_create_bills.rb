class CreateBills < ActiveRecord::Migration[8.1]
  def change
    create_table :bills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :issue, null: false, foreign_key: true
      t.date :billed_on, null: false
      t.decimal :rent_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :late_fine, precision: 10, scale: 2, null: false, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.text :notes

      t.timestamps
    end
  end
end
