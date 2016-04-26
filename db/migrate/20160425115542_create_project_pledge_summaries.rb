class CreateProjectPledgeSummaries < ActiveRecord::Migration
  def change
    create_table :project_pledge_summaries do |t|
      t.string :project_code, null: false
      t.integer :funded_count
      t.float :funded_amount

      t.timestamps null: false

      t.index :project_code, unique: true
    end
  end
end
