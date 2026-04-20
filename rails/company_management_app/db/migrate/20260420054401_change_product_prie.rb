class ChangeProductPrie < ActiveRecord::Migration[8.1]
  def change
    def up
      change_table :products do |t|
        t.change :price, :string
      end
    end

    def down
      change_table :products do |t|
        t.change :price, :integer
      end
    end
  end
end
