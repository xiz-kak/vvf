require 'rails_helper'

RSpec.describe Reward, type: :model do

  describe '#price_f' do
    it 'places delimiters and rounds to 2 digits of decimal places' do
      r = create(:reward)
      expect(r.price_f).to eq '1300.50'
    end
  end

end
