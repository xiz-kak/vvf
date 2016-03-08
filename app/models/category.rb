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
  has_many :category_locales, dependent: :destroy
  accepts_nested_attributes_for :category_locales, allow_destroy: true

  def name(locale)
    category_locales.localed(locale).name
  end
end
