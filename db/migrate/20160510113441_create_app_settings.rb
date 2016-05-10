class CreateAppSettings < ActiveRecord::Migration
  def change
    create_table :app_settings do |t|
      t.string :key
      t.string :value
      t.string :description

      t.timestamps null: false
    end
  end
end
