class CreateDivisionLocales < ActiveRecord::Migration
  def change
    create_table :division_locales do |t|
      t.belongs_to :division, index: true, foreign_key: true
      t.belongs_to :language, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
