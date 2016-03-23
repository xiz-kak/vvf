# == Schema Information
#
# Table name: nations
#
#  id           :integer          not null, primary key
#  name         :string
#  alpha_2_code :string
#  alpha_3_code :string
#  numeric_code :string
#  is_to_ship   :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Nation < ActiveRecord::Base
  has_many :reward_shippings, inverse_of: :reward

  scope :shipping_destinations, -> { where(is_to_ship: true).order(:name) }
end
