class AddWorkflowToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :code, :integer
    add_column :rewards, :project_code, :string
    add_column :rewards, :view_begin_at, :datetime
    add_column :rewards, :view_end_at, :datetime
    add_column :rewards, :status_div, :integer

    add_index :rewards, :project_code
  end
end
