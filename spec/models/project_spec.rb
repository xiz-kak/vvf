require 'rails_helper'

RSpec.describe Project, type: :model do

  describe '#main_language' do
    it 'returns Language instance of :vi for Vietnamese project' do
      p = create(:project)
      expect(p.main_language.code).to eq 'vi'
    end
  end

  describe '#goal_amount_z' do
    it 'rounds to 2 digits of decimal places' do
      p = create(:project)
      expect(p.goal_amount_z).to eq '1300.50'
    end
  end

  describe '#get_or_new_locale' do
    it 'returns existing ProjectLocale instance of :vi' do
      p = create(:project)
      l = Language.coded(:vi)
      expect(p.get_or_new_locale(l.id).language_id).to eq l.id
      expect(p.get_or_new_locale(l.id)).not_to be_new_record
    end

    it 'returns new ProjectLocale instance of :ja' do
      p = create(:project)
      l = Language.coded(:ja)
      expect(p.get_or_new_locale(l.id).language_id).to eq l.id
      expect(p.get_or_new_locale(l.id)).to be_new_record
    end
  end

  describe '#get_or_new_header' do
    it 'returns existing ProjectHeader instance of :vi' do
      p = create(:project)
      l = Language.coded(:vi)
      expect(p.get_or_new_header(l.id).language_id).to eq l.id
      expect(p.get_or_new_header(l.id)).not_to be_new_record
    end

    it 'returns new ProjectHeader instance of :ja' do
      p = create(:project)
      l = Language.coded(:ja)
      expect(p.get_or_new_header(l.id).language_id).to eq l.id
      expect(p.get_or_new_header(l.id)).to be_new_record
    end
  end

  describe '#get_or_new_content' do
    it 'returns existing ProjectContent instance of :vi' do
      p = create(:project)
      l = Language.coded(:vi)
      expect(p.get_or_new_content(l.id).language_id).to eq l.id
      expect(p.get_or_new_content(l.id)).not_to be_new_record
    end

    it 'returns new ProjectContent instance of :ja' do
      p = create(:project)
      l = Language.coded(:ja)
      expect(p.get_or_new_content(l.id).language_id).to eq l.id
      expect(p.get_or_new_content(l.id)).to be_new_record
    end
  end

end
