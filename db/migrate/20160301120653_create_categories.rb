class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
