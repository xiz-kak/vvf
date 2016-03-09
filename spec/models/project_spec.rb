require 'rails_helper'

RSpec.describe Project, type: :model do

  describe '#main_language' do
    it 'returns Language instance of :vi for Vietnamese project' do
      p = create(:project)
      expect(p.main_language.code).to eq 'vi'
    end
  end

  describe '#goal_amount_f' do
    it 'rounds to 2 digits of decimal places' do
      p = create(:project)
      expect(p.goal_amount_f).to eq '1300.50'
    end
  end

  describe '#get_or_new_locale' do
    it 'returns existing ProjectLocale instance of :vi' do
      p = create(:project)
      expect(p.get_or_new_locale(:vi).language_id).to eq Language.coded(:vi).id
      expect(p.get_or_new_locale(:vi)).not_to be_new_record
    end

    it 'returns new ProjectLocale instance of :ja' do
      p = create(:project)
      expect(p.get_or_new_locale(:ja).language_id).to eq Language.coded(:ja).id
      expect(p.get_or_new_locale(:ja)).to be_new_record
    end
  end

  describe '#get_or_new_header' do
    it 'returns existing ProjectHeader instance of :vi' do
      p = create(:project)
      expect(p.get_or_new_header(:vi).language_id).to eq Language.coded(:vi).id
      expect(p.get_or_new_header(:vi)).not_to be_new_record
    end

    it 'returns new ProjectHeader instance of :ja' do
      p = create(:project)
      expect(p.get_or_new_header(:ja).language_id).to eq Language.coded(:ja).id
      expect(p.get_or_new_header(:ja)).to be_new_record
    end
  end

  describe '#get_or_new_content' do
    it 'returns existing ProjectContent instance of :vi' do
      p = create(:project)
      expect(p.get_or_new_content(:vi).language_id).to eq Language.coded(:vi).id
      expect(p.get_or_new_content(:vi)).not_to be_new_record
    end

    it 'returns new ProjectContent instance of :ja' do
      p = create(:project)
      expect(p.get_or_new_content(:ja).language_id).to eq Language.coded(:ja).id
      expect(p.get_or_new_content(:ja)).to be_new_record
    end
  end
end
