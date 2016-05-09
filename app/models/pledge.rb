# == Schema Information
#
# Table name: pledges
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  pledged_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  reward_code :integer
#
# Indexes
#
#  index_pledges_on_reward_code  (reward_code)
#  index_pledges_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_fab7fc217d  (user_id => users.id)
#

class Pledge < ActiveRecord::Base
  belongs_to :reward, primary_key: :code, foreign_key: :reward_code, inverse_of: :pledges
  belongs_to :user

  has_one :pledge_payment, dependent: :destroy, inverse_of: :pledge
  accepts_nested_attributes_for :pledge_payment, allow_destroy: true

  has_one :pledge_shipping, dependent: :destroy, inverse_of: :pledge
  accepts_nested_attributes_for :pledge_shipping, allow_destroy: true

  scope :preapproved, lambda {
    joins(:pledge_payment).
    where('pledge_payments.status in (?, ?)', Divs::PledgePaymentStatus::PREAPPROVED.to_i, Divs::PledgePaymentStatus::PAY_ERROR.to_i)
  }

  validate :pledgeable

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

  def approve!
    pledge_payment.payment_status = Divs::PledgePaymentStatus::APPROVED
  end

  def cancel!
    pledge_payment.payment_status = Divs::PledgePaymentStatus::APPROVED
  end

  def pay_error!
    pledge_payment.payment_status = Divs::PledgePaymentStatus::PAY_ERROR
  end

  private

  def pledgeable
    unless reward.project.status_div_active?
      errors[:base] << 'This project is not active anymore.'
    end

    #TODO: 残数確認
  end
end
