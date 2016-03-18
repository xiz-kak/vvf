require 'rails_helper'

RSpec.describe "PaymentVendors", type: :request do
  describe "GET /payment_vendors" do
    it "works! (now write some real specs)" do
      get payment_vendors_path
      expect(response).to have_http_status(200)
    end
  end
end
