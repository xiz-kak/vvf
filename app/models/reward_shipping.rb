# == Schema Information
#
# Table name: reward_shippings
#
#  id            :integer          not null, primary key
#  reward_id     :integer
#  nation_id     :integer
#  shipping_rate :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_reward_shippings_on_nation_id  (nation_id)
#  index_reward_shippings_on_reward_id  (reward_id)
#
# Foreign Keys
#
#  fk_rails_287b9e038a  (nation_id => nations.id)
#  fk_rails_6e2f6e4bf9  (reward_id => rewards.id)
#

class RewardShipping < ActiveRecord::Base
  belongs_to :reward, inverse_of: :reward_shippings
  belongs_to :nation, inverse_of: :reward_shippings

  validates :nation_id, presence: true
  validates :shipping_rate, presence: true

  def shipping_rate_z
    ApplicationController.helpers.number_with_precision(self.shipping_rate,
                                                        precision: 2, separator: '.')
  end

  def shipping_rate_f
    ApplicationController.helpers.number_with_delimiter(shipping_rate_z,
                                                        delimiter: ',', separator: '.')
  end
end
