class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.datetime :begin_at

      t.timestamps null: false
    end
  end
end
