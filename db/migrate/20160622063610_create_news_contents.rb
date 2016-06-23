class CreateNewsContents < ActiveRecord::Migration
  def change
    create_table :news_contents do |t|
      t.belongs_to :news, index: true, foreign_key: true
      t.belongs_to :language, index: true, foreign_key: true
      t.string :title
      t.string :body

      t.timestamps null: false
    end
  end
end
