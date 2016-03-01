require 'rails_helper'

RSpec.describe "CategoryLocales", type: :request do
  describe "GET /category_locales" do
    it "works! (now write some real specs)" do
      get category_locales_path
      expect(response).to have_http_status(200)
    end
  end
end
