class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.belongs_to :project, index: true, foreign_key: true
      t.float :price
      t.integer :count

      t.timestamps null: false
    end
  end
end
