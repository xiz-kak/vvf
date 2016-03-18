class CreatePaymentVendors < ActiveRecord::Migration
  def change
    create_table :payment_vendors do |t|
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
