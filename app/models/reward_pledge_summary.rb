# == Schema Information
#
# Table name: reward_pledge_summaries
#
#  id           :integer          not null, primary key
#  reward_code  :integer          not null
#  funded_count :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_reward_pledge_summaries_on_reward_code  (reward_code) UNIQUE
#

class RewardPledgeSummary < ActiveRecord::Base
  belongs_to :reward, -> { active }, primary_key: :code, foreign_key: :reward_code, inverse_of: :reward_pledge_summary

  def self.pledge(reward_code)
    sum = RewardPledgeSummary.find_by(reward_code: reward_code)
    sum = RewardPledgeSummary.new(reward_code: reward_code, funded_count: 0) if sum.blank?

    sum.funded_count += 1

    sum.save
  end

  def self.revert(reward_code)
    sum = RewardPledgeSummary.find_by(reward_code: reward_code)

    if sum.present?
      sum.funded_count -= 1

      sum.save
    else
      logger.error("Illegal revert of RewardPledgeSummary. Error: Not Exist. rewardCode: #{reward_code}")
    end
  end
end
