class AddShipsToDivToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :ships_to_div, :integer
  end
end
