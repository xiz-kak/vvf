# == Schema Information
#
# Table name: rewards
#
#  id                    :integer          not null, primary key
#  project_id            :integer
#  price                 :float
#  count                 :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  estimated_delivery    :datetime
#  ships_to_div          :integer
#  default_shipping_rate :float
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

  bind_inum :ships_to_div, Divs::RewardShipsTo

  has_many :reward_contents, dependent: :destroy, inverse_of: :reward
  accepts_nested_attributes_for :reward_contents, allow_destroy: true

  has_many :reward_shippings, -> { order 'nation_id' }, dependent: :destroy, inverse_of: :reward
  accepts_nested_attributes_for :reward_shippings, allow_destroy: true

  has_many :pledges, dependent: :destroy, inverse_of: :reward

  validates :project, presence: true
  validates :price, presence: true
  validates :count, presence: true
  # default_shipping_rate is required if ships to anywhere_in_the_world
  validates :default_shipping_rate, presence: true, if: Proc.new { self.ships_to_div == 3 }
  validate :reward_shipping_is_required

  def title(locale)
    localed_content(locale).title
  end

  def image(locale)
    localed_content(locale).image
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

  def default_shipping_rate_z
    ApplicationController.helpers.number_with_precision(self.default_shipping_rate,
                                                        precision: 2, separator: '.')
  end

  def default_shipping_rate_f
    ApplicationController.helpers.number_with_delimiter(default_shipping_rate_z,
                                                        delimiter: ',', separator: '.')
  end

  def shipping_rate(nation_id)
    if ships_to_div == 1
      sr = 0.00
    elsif ships_to_div == 2
      sr = reward_shippings.find_by(nation_id: nation_id).shipping_rate_z
    elsif ships_to_div == 3
      sr = reward_shippings.find_by(nation_id: nation_id).try(:shipping_rate_z)
      sr = default_shipping_rate_z if sr.blank?
    end
    sr
  end

  def get_or_new_content(language_id)
    rc = reward_contents.find { |r| r.language_id == language_id }
    rc = reward_contents.langed(language_id)
    rc = reward_contents.build(language_id: language_id) if rc.blank?
    rc
  end

  private

  def reward_shipping_is_required
    if ships_to_div == Divs::RewardShipsTo::CERTAIN_COUNTRIES
      errors.add(:ships_to, ':At lease one nation is required to be specified.') if reward_shippings.size == 0
    end
  end

  def localed_content(locale)
    rc = reward_contents.localed(locale)
    rc = reward_contents.find_by(language_id: project.main_language.id) if rc.blank?
    rc
  end
end
