# == Schema Information
#
# Table name: app_settings
#
#  id          :integer          not null, primary key
#  key         :string
#  value       :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AppSetting < ActiveRecord::Base

  DEFAULT_COMMISSION_RATE = 'DEFAULT_COMMISSION_RATE'

  scope :default_commission_rate, -> { find_by(key: DEFAULT_COMMISSION_RATE).value.to_i }
end
