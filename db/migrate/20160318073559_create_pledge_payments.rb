class CreatePledgePayments < ActiveRecord::Migration
  def change
    create_table :pledge_payments do |t|
      t.belongs_to :pledge, index: true, foreign_key: true
      t.float :amount
      t.float :shipping_rate
      t.float :total_amount
      t.integer :payment_method_div
      t.belongs_to :payment_vendor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
