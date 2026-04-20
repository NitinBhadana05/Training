class CreatePost1s < ActiveRecord::Migration[8.1]
  def change
    create_table :post1s do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
