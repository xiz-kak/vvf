require 'rails_helper'

RSpec.describe Reward, type: :model do

  describe '#price_z' do
    it 'places delimiters and rounds to 2 digits of decimal places' do
      r = create(:reward_wo_validation)
      expect(r.price_z).to eq '1300.50'
    end
  end

end
