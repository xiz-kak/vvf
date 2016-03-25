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
#  nation_id  :integer
#
# Indexes
#
#  index_pledge_shippings_on_nation_id  (nation_id)
#  index_pledge_shippings_on_pledge_id  (pledge_id)
#
# Foreign Keys
#
#  fk_rails_9da1daa512  (nation_id => nations.id)
#  fk_rails_b58856cba5  (pledge_id => pledges.id)
#

class PledgeShipping < ActiveRecord::Base
  belongs_to :pledge, inverse_of: :pledge_shipping
  belongs_to :nation, inverse_of: :pledge_shippings

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :nation_id, presence: true
  validates :tel, presence: true
  validates :zip_code, presence: true
  validates :address1, presence: true
end
