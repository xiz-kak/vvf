class CreatePledgeShippings < ActiveRecord::Migration
  def change
    create_table :pledge_shippings do |t|
      t.belongs_to :pledge, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :tel
      t.string :zip_code
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4

      t.timestamps null: false
    end
  end
end
