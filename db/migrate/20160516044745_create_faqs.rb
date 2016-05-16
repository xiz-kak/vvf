class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.integer :sort_order
      t.integer :faq_category_div

      t.timestamps null: false
    end
  end
end
