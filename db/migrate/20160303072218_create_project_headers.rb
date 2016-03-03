class CreateProjectHeaders < ActiveRecord::Migration
  def change
    create_table :project_headers do |t|
      t.belongs_to :project, index: true, foreign_key: true
      t.belongs_to :language, index: true, foreign_key: true
      t.string :title
      t.string :image_path

      t.timestamps null: false
    end
  end
end
