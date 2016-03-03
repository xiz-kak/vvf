class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.float :goal_amount
      t.integer :duration_days

      t.timestamps null: false
    end
  end
end
