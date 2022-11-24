require "rails_helper"

RSpec.describe 'Location', type: :request do
  describe 'GET /location.json' do
    it "includes the location" do
      location = create(:location)
      get location_path(location), params: { start_date: "2022-10-20", end_date: "2022-10-21" }

      expect(response.body).to include(location.id.to_s)
    end  
  end
end