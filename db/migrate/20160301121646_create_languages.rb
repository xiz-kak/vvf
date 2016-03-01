class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :code
      t.string :name
      t.string :name_en
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
