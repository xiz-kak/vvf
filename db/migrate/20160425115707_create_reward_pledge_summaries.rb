class CreateRewardPledgeSummaries < ActiveRecord::Migration
  def change
    create_table :reward_pledge_summaries do |t|
      t.integer :reward_code
      t.integer :funded_count

      t.timestamps null: false
    end
  end
end
