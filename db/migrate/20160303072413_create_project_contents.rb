class CreateProjectContents < ActiveRecord::Migration
  def change
    create_table :project_contents do |t|
      t.belongs_to :project, index: true, foreign_key: true
      t.belongs_to :language, index: true, foreign_key: true
      t.text :body

      t.timestamps null: false
    end
  end
end
