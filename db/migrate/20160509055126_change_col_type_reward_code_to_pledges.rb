class ChangeColTypeRewardCodeToPledges < ActiveRecord::Migration
  def change
    change_column :pledges, :reward_code, 'integer USING CAST(reward_code AS integer)'
  end
end
