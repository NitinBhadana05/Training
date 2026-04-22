class CreateFines < ActiveRecord::Migration[8.1]
  def change
    create_table :fines do |t|
      t.references :rental, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.string :reason

      t.timestamps
    end
  end
end
