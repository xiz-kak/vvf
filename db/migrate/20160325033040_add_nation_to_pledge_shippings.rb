class AddNationToPledgeShippings < ActiveRecord::Migration
  def change
    add_reference :pledge_shippings, :nation, index: true, foreign_key: true
  end
end
