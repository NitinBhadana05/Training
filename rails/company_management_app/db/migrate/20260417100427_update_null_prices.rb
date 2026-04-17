class UpdateNullPrices < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE products SET price = 0 WHERE price IS NULL"
  end

  def down
    # optional rollback logic
    execute "UPDATE products SET price = NULL WHERE price = 0"
  end
end