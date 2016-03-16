class AddAppliedBeginDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :applied_begin_date, :datetime
  end
end
