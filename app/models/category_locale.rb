# == Schema Information
#
# Table name: category_locales
#
#  id          :integer          not null, primary key
#  category_id :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :integer
#
# Indexes
#
#  index_category_locales_on_category_id  (category_id)
#  index_category_locales_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_4e50792ee4  (language_id => languages.id)
#  fk_rails_89eff8d58a  (category_id => categories.id)
#

class CategoryLocale < ActiveRecord::Base
  belongs_to :category
  belongs_to :language

  validates :language, presence: true, uniqueness: { scope: :category_id }

  include LocaleBase
end
