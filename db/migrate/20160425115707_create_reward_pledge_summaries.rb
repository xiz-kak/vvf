class CreateRewardPledgeSummaries < ActiveRecord::Migration
  def change
    create_table :reward_pledge_summaries do |t|
      t.integer :reward_code, null: false
      t.integer :funded_count

      t.timestamps null: false

      t.index :reward_code, unique: true
    end
  end
end
