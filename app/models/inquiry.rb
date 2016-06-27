# == Schema Information
#
# Table name: inquiries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  email      :string
#  subject    :string
#  details    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_inquiries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7fdff2c1ec  (user_id => users.id)
#

class Inquiry < ActiveRecord::Base
  belongs_to :user
end
