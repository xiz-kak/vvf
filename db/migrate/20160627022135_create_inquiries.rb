class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :name
      t.string :email
      t.string :subject
      t.string :details

      t.timestamps null: false
    end
  end
end
