class AddStatusToPledgePayment < ActiveRecord::Migration
  def change
    add_column :pledge_payments, :status, :integer, default: 1, null: false
  end
end
