class AddBlurbToProjectHeaders < ActiveRecord::Migration
  def change
    add_column :project_headers, :blurb, :string
  end
end
