class CreateProjectPledgeSummaries < ActiveRecord::Migration
  def change
    create_table :project_pledge_summaries do |t|
      t.string :project_code
      t.integer :funded_count
      t.float :funded_amount

      t.timestamps null: false
    end
  end
end
