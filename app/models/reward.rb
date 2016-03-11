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

  def title(locale)
    localed_content(locale).title
  end

  def image_path(locale)
    localed_content(locale).image_path
  end

  def description(locale)
    localed_content(locale).description
  end

  def price_z
    ApplicationController.helpers.number_with_precision(self.price,
                                                        precision: 2, separator: '.')
  end

  def price_f
    ApplicationController.helpers.number_with_delimiter(price_z,
                                                        delimiter: ',', separator: '.')
  end

  def get_or_new_content(language_id)
    rc = reward_contents.find { |r| r.language_id == language_id }
    rc = reward_contents.langed(language_id)
    rc = reward_contents.build(language_id: language_id) if rc.blank?
    rc
  end

  private

  def localed_content(locale)
    rc = reward_contents.localed(locale)
    rc = reward_contents.find_by(language_id: project.main_language.id) if rc.blank?
    rc
  end
end
