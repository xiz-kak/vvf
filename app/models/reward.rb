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
  has_many :reward_contents, dependent: :destroy, inverse_of: :reward
  accepts_nested_attributes_for :reward_contents, allow_destroy: true
  after_initialize :build_children, if: :new_record?

  validates :project, presence: true
  validates :price, presence: true
  validates :count, presence: true

  def price_f
    ApplicationController.helpers.number_with_precision(self.price, precision: 2)
  end

  private

  def build_children
    reward_contents.build
  end
end
