require "rails_helper"

RSpec.describe 'Locations', type: :request do
  describe 'GET /locations.json' do
    it "includes the location" do
      location = create(:location)
      get locations_path

      expect(response.body).to include(location.id.to_s)
    end  
  end

  describe 'GET /location.json' do
    it "includes the location and the search range" do
      location = create(:location)
      get location_path(location), params: { start_date: "2022-10-20", end_date: "2022-10-21" }

      expect(response.body).to include("20.10.2022", "21.10.2022", location.id.to_s)
    end  
  end
end