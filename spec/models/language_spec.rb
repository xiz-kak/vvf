require 'rails_helper'

RSpec.describe Language, type: :model do
  describe '#locale_to_lang' do
    it 'returns language_id of :en for argument :en' do
      expect(Language.locale_to_lang(:en)).to eq Language.coded(:en).id
    end

    it 'returns language_id of :en for argument "en"' do
      expect(Language.locale_to_lang('en')).to eq Language.coded(:en).id
    end

    it 'returns language_id of :vi for argument :vi' do
      expect(Language.locale_to_lang(:vi)).to eq Language.coded(:vi).id
    end

    it 'returns language_id of :vi for argument "vi"' do
      expect(Language.locale_to_lang('vi')).to eq Language.coded(:vi).id
    end

    it 'returns language_id of :ja for argument :ja' do
      expect(Language.locale_to_lang(:ja)).to eq Language.coded(:ja).id
    end

    it 'returns language_id of :ja for argument "ja"' do
      expect(Language.locale_to_lang('ja')).to eq Language.coded(:ja).id
    end

    it 'returns language_id of :en for argument nil' do
      expect(Language.locale_to_lang(nil)).to eq Language.coded(:en).id
    end

    it 'returns language_id of :en for argument ""' do
      expect(Language.locale_to_lang('')).to eq Language.coded(:en).id
    end
  end

  describe '#lang_to_locale' do
    it 'returns "en" for language_id of :en' do
      expect(Language.lang_to_locale(Language.coded(:en).id)).to eq 'en'
    end

    it 'returns "vi" for language_id of :vi' do
      expect(Language.lang_to_locale(Language.coded(:vi).id)).to eq 'vi'
    end

    it 'returns "ja" for language_id of :ja' do
      expect(Language.lang_to_locale(Language.coded(:ja).id)).to eq 'ja'
    end
  end
end
