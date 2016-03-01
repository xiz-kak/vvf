class AddLanguageToCategoryLocales < ActiveRecord::Migration
  def change
    add_reference :category_locales, :language, index: true, foreign_key: true
  end
end
