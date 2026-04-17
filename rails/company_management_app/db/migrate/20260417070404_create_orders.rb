class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :user
      t.date :issue_date
      t.date :return_date
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
