class CreateSignups < ActiveRecord::Migration[8.1]
  def change
    create_table :signups do |t|
      t.boolean :terms_and_conditions

      t.timestamps
    end
  end
end
