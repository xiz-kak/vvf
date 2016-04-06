class AddWorkflowToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :code, :integer
  end
end
