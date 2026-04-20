class RemoveColumnFromPratice < ActiveRecord::Migration[8.1]
  def change
    remove_column :pratices, :status, :string
  end
end
