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

  validates :project, presence: true
  validates :price, presence: true
  validates :count, presence: true

  def price_z
    ApplicationController.helpers.number_with_precision(self.price, precision: 2)
  end

  def get_or_new_content(locale)
    rc = reward_contents.find { |r| r.language_id == Language.locale_to_lang(locale) }
    rc = reward_contents.localed(locale)
    rc = reward_contents.build(language_id: Language.locale_to_lang(locale)) if rc.blank?
    rc
  end

end
