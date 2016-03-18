# == Schema Information
#
# Table name: payment_vendor_locales
#
#  id                :integer          not null, primary key
#  payment_vendor_id :integer
#  language_id       :integer
#  logo_image        :string
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_payment_vendor_locales_on_language_id        (language_id)
#  index_payment_vendor_locales_on_payment_vendor_id  (payment_vendor_id)
#
# Foreign Keys
#
#  fk_rails_9c2ef21eb0  (payment_vendor_id => payment_vendors.id)
#  fk_rails_bf959c84a7  (language_id => languages.id)
#

class PaymentVendorLocale < ActiveRecord::Base
  belongs_to :payment_vendor
  belongs_to :language

  validates :language, presence: true, uniqueness: { scope: :payment_vendor_id }

  mount_uploader :logo_image, ImageUploader

  include LocaleBase
end
