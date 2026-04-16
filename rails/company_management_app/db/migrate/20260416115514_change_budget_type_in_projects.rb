class ChangeBudgetTypeInProjects < ActiveRecord::Migration[8.1]
  def change
    change_column :projects, :budget, :decimal, precision: 12, scale: 2
  end
end
