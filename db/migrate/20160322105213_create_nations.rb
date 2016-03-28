class CreateNations < ActiveRecord::Migration
  def change
    create_table :nations do |t|
      t.string :name
      t.string :alpha_2_code
      t.string :alpha_3_code
      t.string :numeric_code
      t.boolean :is_to_ship

      t.timestamps null: false
    end
  end
end
