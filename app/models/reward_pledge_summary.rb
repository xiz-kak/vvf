# == Schema Information
#
# Table name: reward_pledge_summaries
#
#  id           :integer          not null, primary key
#  reward_code  :integer
#  funded_count :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class RewardPledgeSummary < ActiveRecord::Base
end
