class AddCommissionRateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :commission_rate, :integer
  end
end
