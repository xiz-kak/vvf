class CreateFaqContents < ActiveRecord::Migration
  def change
    create_table :faq_contents do |t|
      t.belongs_to :faq, index: true, foreign_key: true
      t.belongs_to :language, index: true, foreign_key: true
      t.string :question
      t.string :answer
      t.string :answer_detail

      t.timestamps null: false
    end
  end
end
