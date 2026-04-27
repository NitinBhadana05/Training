class AddPaidOnToBills < ActiveRecord::Migration[8.1]
  def change
    add_column :bills, :paid_on, :date
  end
end
