class AddUniqueIndexAssigns < ActiveRecord::Migration[8.1]
  def change
    add_index :assigns, [:employee_id, :project_id], unique: true
  end

  
end
