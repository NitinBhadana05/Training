class ChangeSalaryTypeInEmployees < ActiveRecord::Migration[8.1]
  def change
    change_column :employees, :salary, :decimal, precision: 10, scale: 2
  end
end
