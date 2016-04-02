require 'rails_helper'

RSpec.describe Language do
  let!(:en) { FactoryGirl.create(:language, :en) }
  let!(:vi) { FactoryGirl.create(:language, :vi) }
  let!(:ja) { FactoryGirl.create(:language, :ja) }

  describe '.locale_to_lang' do
    subject { described_class.locale_to_lang(locale) }
    context 'when locale is blank' do
      let(:locale) { 'en' }
      it { is_expected.to eq en.id }
    end
    context 'when locale is not blank' do
      context 'when locale is vi' do
        let(:locale) { 'vi' }
        it { is_expected.to eq vi.id }
      end
      context 'when locale is ja' do
        let(:locale) { 'ja' }
        it { is_expected.to eq ja.id }
      end
    end
  end

  describe '.lang_to_locale' do
    subject { described_class.lang_to_locale(lang_id) }
    context 'when lang_id is en.id' do
      let(:lang_id) { en.id }
      it { is_expected.to eq en.code }
    end
    context 'when lang_id is vi.id' do
      let(:lang_id) { vi.id }
      it { is_expected.to eq vi.code }
    end
    context 'when lang_id is ja.id' do
      let(:lang_id) { ja.id }
      it { is_expected.to eq ja.code }
    end
  end
end
