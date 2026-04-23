class AddNameAndPriceToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :name, :string
  end
end
