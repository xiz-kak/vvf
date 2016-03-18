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
  belongs_to :payment_vendor
  belongs_to :pledge, inverse_of: :pledge_payment
end
