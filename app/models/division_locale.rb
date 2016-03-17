# == Schema Information
#
# Table name: division_locales
#
#  id          :integer          not null, primary key
#  division_id :integer
#  language_id :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_division_locales_on_division_id  (division_id)
#  index_division_locales_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_3a11ae5767  (division_id => divisions.id)
#  fk_rails_7a0504925f  (language_id => languages.id)
#

class DivisionLocale < ActiveRecord::Base
  belongs_to :division
  belongs_to :language

  validates :language, presence: true, uniqueness: { scope: :division_id }

  include LocaleBase
end
