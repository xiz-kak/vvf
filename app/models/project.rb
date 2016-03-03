# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  category_id   :integer
#  goal_amount   :float
#  duration_days :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_projects_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_2ad2693164  (category_id => categories.id)
#

class Project < ActiveRecord::Base
  belongs_to :category
  has_many :project_headers
  has_many :project_contents
  has_many :rewards
  accepts_nested_attributes_for :project_headers, allow_destroy: true
  accepts_nested_attributes_for :project_contents, allow_destroy: true
  accepts_nested_attributes_for :rewards, allow_destroy: true
end
