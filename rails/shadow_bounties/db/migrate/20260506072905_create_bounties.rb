class CreateBounties < ActiveRecord::Migration[8.1]
  def change
    create_table :bounties do |t|
      t.string :target_name
      t.integer :threat_level
      t.string :last_seen
      t.integer :reward_ammount
      t.string :status
      t.string :poster_image

      t.timestamps
    end
  end
end
