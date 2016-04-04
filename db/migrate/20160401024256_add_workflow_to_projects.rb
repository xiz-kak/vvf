class AddWorkflowToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :code, :string
    add_column :projects, :begin_at, :datetime
    add_column :projects, :end_at, :datetime
    add_column :projects, :view_begin_at, :datetime
    add_column :projects, :view_end_at, :datetime
  end
end
