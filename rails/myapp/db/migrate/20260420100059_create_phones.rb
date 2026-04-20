class CreatePhones < ActiveRecord::Migration[8.1]
  def change
    create_table :phones do |t|
      t.string :phone

      t.timestamps
    end
  end
end
