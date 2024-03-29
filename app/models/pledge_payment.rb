# == Schema Information
#
# Table name: pledge_payments
#
#  id                 :integer          not null, primary key
#  pledge_id          :integer
#  amount             :float
#  shipping_rate      :float
#  total_amount       :float
#  payment_method_div :integer
#  payment_vendor_id  :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  preapproval_key    :string
#  status             :integer          default(1), not null
#
# Indexes
#
#  index_pledge_payments_on_payment_vendor_id  (payment_vendor_id)
#  index_pledge_payments_on_pledge_id          (pledge_id)
#
# Foreign Keys
#
#  fk_rails_85fc69a8fa  (payment_vendor_id => payment_vendors.id)
#  fk_rails_a3de73fbda  (pledge_id => pledges.id)
#

class PledgePayment < ActiveRecord::Base
  bind_inum :status, Divs::PledgePaymentStatus

  belongs_to :payment_vendor
  belongs_to :pledge, inverse_of: :pledge_payment

  before_validation :calculate_amount

  validates :amount, presence: true
  validates :payment_method_div, presence: true
  validates :payment_vendor_id, presence: true

  include NumberFormatter

  def amount_z
    to_currency_z(amount, :usd)
  end

  def amount_f
    to_currency_f(amount, :usd)
  end

  def shipping_rate_z
    to_currency_z(shipping_rate, :usd)
  end

  def shipping_rate_f
    to_currency_f(shipping_rate, :usd)
  end

  def total_amount_z
    to_currency_z(total_amount, :usd)
  end

  def total_amount_f
    to_currency_f(total_amount, :usd)
  end

  def payment_status=(arg)
    update_attribute(:status, arg)
  end

  def payment_preapproval_key=(arg)
    update_attribute(:preapproval_key, arg)
  end

  private

  def calculate_amount
    r = self.pledge.reward
    n_id = self.pledge.pledge_shipping.try(:nation_id)
    self.amount = r.price
    self.shipping_rate = n_id ? r.shipping_rate(n_id) : 0
    self.total_amount = amount + shipping_rate
  end
end
