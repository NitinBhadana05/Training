class AddBillingFieldsToBooksAndIssues < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :rental_fee, :decimal, precision: 10, scale: 2, null: false, default: 25
    add_column :books, :purchase_price, :decimal, precision: 10, scale: 2, null: false, default: 350

    add_column :issues, :transaction_type, :string, null: false, default: "rent"
    add_column :issues, :amount, :decimal, precision: 10, scale: 2, null: false, default: 0
    add_column :issues, :previous_balance, :decimal, precision: 10, scale: 2, null: false, default: 0
    add_column :issues, :balance_after, :decimal, precision: 10, scale: 2, null: false, default: 0
  end
end
