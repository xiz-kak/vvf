class AddStatusDivToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :status_div, :integer
  end
end
