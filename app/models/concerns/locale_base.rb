module LocaleBase
  extend ActiveSupport::Concern

  included do
    # scope :localed, -> (locale){ find_by(language_id: Language.locale_to_lang(locale)) }
    # scope returns .all when nil. orz...

    def self.localed(locale)
      find_by(language_id: Language.locale_to_lang(locale))
    end

    def self.langed(language_id)
      find_by(language_id: language_id)
    end
  end
end
