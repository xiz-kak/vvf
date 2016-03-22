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
end
