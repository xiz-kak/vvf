class AddPaypalAccountToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :paypal_account, :string
  end
end
