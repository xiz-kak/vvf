module LocaleBase
  extend ActiveSupport::Concern

  included do
    # scope :localed, -> (locale){ find_by(language_id: Language.locale_to_lang(locale)) }
    # scope :localed, -> (locale){ where(language_id: Language.locale_to_lang(locale)).first }
    #
    def self.localed(locale)
      find_by(language_id: Language.locale_to_lang(locale))
    end
  end

end
