class RenameImagePathToProjectHeaders < ActiveRecord::Migration
  def change
    rename_column :project_headers, :image_path, :image
    rename_column :reward_contents, :image_path, :image
  end
end
