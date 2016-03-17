class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.integer :code
      t.integer :val
      t.integer :sort_order
      t.string :description

      t.timestamps null: false
    end
  end
end
