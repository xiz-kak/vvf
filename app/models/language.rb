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
  has_many :project_locales
  has_many :project_headers
  has_many :project_contents

  scope :sorted, -> { order(:sort_order) }
  scope :coded, -> (code) { find_by(code: code) }

  def self.locale_to_lang(locale)
    if locale.blank?
      language_id = Language.find_by(code: 'en').id
    else
      language_id = Language.find_by(code: locale.to_s[0,2]).id
    end
    language_id
  end

  def self.lang_to_locale(lang_id)
    Language.find(lang_id).code
  end
end
