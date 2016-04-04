class AddRewardCodeToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :reward_code, :string

    add_index :pledges, :reward_code
  end
end
