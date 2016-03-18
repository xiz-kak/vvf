# == Schema Information
#
# Table name: pledge_shippings
#
#  id         :integer          not null, primary key
#  pledge_id  :integer
#  first_name :string
#  last_name  :string
#  tel        :string
#  zip_code   :string
#  address1   :string
#  address2   :string
#  address3   :string
#  address4   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_pledge_shippings_on_pledge_id  (pledge_id)
#
# Foreign Keys
#
#  fk_rails_b58856cba5  (pledge_id => pledges.id)
#

class PledgeShipping < ActiveRecord::Base
  belongs_to :pledge, inverse_of: :pledge_shipping
end
