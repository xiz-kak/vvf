class AddDefaultShippingRateToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :default_shipping_rate, :float
  end
end
