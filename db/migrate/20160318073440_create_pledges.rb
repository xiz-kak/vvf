class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.datetime :pledged_at

      t.timestamps null: false
    end
  end
end
