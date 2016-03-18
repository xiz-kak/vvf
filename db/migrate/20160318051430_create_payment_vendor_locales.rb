class CreatePaymentVendorLocales < ActiveRecord::Migration
  def change
    create_table :payment_vendor_locales do |t|
      t.belongs_to :payment_vendor, index: true, foreign_key: true
      t.belongs_to :language, index: true, foreign_key: true
      t.string :logo_image
      t.string :name

      t.timestamps null: false
    end
  end
end
