class AddCoverImageToLegends < ActiveRecord::Migration[8.1]
  def change
    add_column :legends, :cover_image, :string
  end
end
