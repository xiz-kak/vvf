class AddEstimatedDeliveryToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :estimated_delivery, :datetime
  end
end
