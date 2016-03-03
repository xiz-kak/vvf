# == Schema Information
#
# Table name: rewards
#
#  id         :integer          not null, primary key
#  project_id :integer
#  price      :float
#  count      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rewards_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_789cbde8b2  (project_id => projects.id)
#

class Reward < ActiveRecord::Base
  belongs_to :project
  has_many :reward_contents
  accepts_nested_attributes_for :reward_contents, allow_destroy: true
end
