class CreateProjectLocales < ActiveRecord::Migration
  def change
    create_table :project_locales do |t|
      t.belongs_to :project, index: true, foreign_key: true
      t.belongs_to :language, index: true, foreign_key: true
      t.boolean :is_main

      t.timestamps null: false
    end
  end
end
