# == Schema Information
#
# Table name: payment_vendors
#
#  id         :integer          not null, primary key
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PaymentVendor < ActiveRecord::Base
  has_many :payment_vendor_locales, dependent: :destroy
  accepts_nested_attributes_for :payment_vendor_locales, allow_destroy: true

  def name(locale)
    payment_vendor_locales.localed(locale).name
  end

  def logo_image(locale)
    payment_vendor_locales.localed(locale).logo_image
  end

  def get_or_new_locale(language_id)
    pvl = payment_vendor_locales.find { |r| r.language_id == language_id }
    pvl = payment_vendor_locales.langed(language_id) if pvl.blank?
    pvl = payment_vendor_locales.build(language_id: language_id) if pvl.blank?
    pvl
  end
end
