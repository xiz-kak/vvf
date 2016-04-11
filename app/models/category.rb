# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  include SortableBase

  has_many :category_locales, dependent: :destroy
  accepts_nested_attributes_for :category_locales, allow_destroy: true

  def name(locale)
    category_locales.localed(locale).name
  end

  def get_or_new_locale(language_id)
    cl = category_locales.find { |r| r.language_id == language_id }
    cl = category_locales.langed(language_id) if cl.blank?
    cl = category_locales.build(language_id: language_id) if cl.blank?
    cl
  end
end
