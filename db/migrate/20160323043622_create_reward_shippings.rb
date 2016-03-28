class CreateRewardShippings < ActiveRecord::Migration
  def change
    create_table :reward_shippings do |t|
      t.belongs_to :reward, index: true, foreign_key: true
      t.belongs_to :nation, index: true, foreign_key: true
      t.float :shipping_rate

      t.timestamps null: false
    end
  end
end
