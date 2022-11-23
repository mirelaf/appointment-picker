require "rails_helper"

RSpec.describe 'Locations', type: :request do
  describe 'GET /locations.json' do
    it "includes the location" do
      location = create(:location)
      get locations_path

      expect(response.body).to include(location.id.to_s)
    end  
  end
end