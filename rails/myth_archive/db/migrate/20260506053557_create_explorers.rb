class CreateExplorers < ActiveRecord::Migration[8.1]
  def change
    create_table :explorers do |t|
      t.string :codename
      t.integer :reputation
      t.string :region

      t.timestamps
    end
  end
end
