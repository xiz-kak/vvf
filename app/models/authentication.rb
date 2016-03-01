# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  provider   :string           not null
#  uid        :string           not null
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer          default(1), not null
#
# Indexes
#
#  index_authentications_on_provider_and_uid  (provider,uid)
#

class Authentication < ActiveRecord::Base
  belongs_to :user
end
