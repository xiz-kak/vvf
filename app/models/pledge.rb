# == Schema Information
#
# Table name: pledges
#
#  id         :integer          not null, primary key
#  reward_id  :integer
#  user_id    :integer
#  pledged_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_pledges_on_reward_id  (reward_id)
#  index_pledges_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_30e8a356aa  (reward_id => rewards.id)
#  fk_rails_fab7fc217d  (user_id => users.id)
#

class Pledge < ActiveRecord::Base
  belongs_to :reward, inverse_of: :pledges
  belongs_to :user

  has_one :pledge_payment, dependent: :destroy, inverse_of: :pledge
  accepts_nested_attributes_for :pledge_payment, allow_destroy: true

  has_one :pledge_shipping, dependent: :destroy, inverse_of: :pledge
  accepts_nested_attributes_for :pledge_shipping, allow_destroy: true

  def preapproval_key(key)
    payment = pledge_payment || build_pledge_payment
    payment.payment_preapproval_key = key
  end

  def preapprove!
    pledge_payment.payment_status = Divs::PledgePaymentStatus::PREAPPROVED
  end

  def preapprove_error!
    pledge_payment.payment_status = Divs::PledgePaymentStatus::PREAPPROVAL_ERROR
  end
end
