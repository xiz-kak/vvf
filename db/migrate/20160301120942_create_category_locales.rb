class CreateCategoryLocales < ActiveRecord::Migration
  def change
    create_table :category_locales do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
