# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  name_en    :string
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Language < ActiveRecord::Base
  has_many :category_locales
end
