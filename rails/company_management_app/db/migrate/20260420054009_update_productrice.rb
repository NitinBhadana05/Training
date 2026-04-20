class UpdateProductrice < ActiveRecord::Migration[8.1]
  def change
    execute "UPDATE products SET price = 0 WHERE price IS NULL"
  end
end
