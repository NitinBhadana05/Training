class AddColumnToPratice < ActiveRecord::Migration[8.1]
  def change
    add_column :pratices, :status, :string
  end
end
