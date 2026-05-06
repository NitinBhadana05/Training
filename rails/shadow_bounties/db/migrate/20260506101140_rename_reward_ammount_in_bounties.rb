class RenameRewardAmmountInBounties < ActiveRecord::Migration[8.1]
  def change
    rename_column :bounties,
                  :reward_ammount,
                  :reward_amount
  end
end