class AddColumnToPledgePayment < ActiveRecord::Migration
  def change
    add_column :pledge_payments, :preapproval_key, :string
  end
end
