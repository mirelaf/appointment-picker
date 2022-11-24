require "rails_helper"

RSpec.describe 'Location', type: :request do
  describe 'GET /locations/:id/find_slots.json' do
    it "includes the search range and location" do
      location = create(:location)
  
      get location_find_slots_path(location), params: { daterange: "04 Jan 2021 - 06 Jan 2021" }

      expect(response.body).to include("04.01.2021", "06.01.2021", location.id.to_s)
    end

    it "includes existing appointments and lunch break as unavailable times" do
      location = create(:location, lunch_start: DateTime.parse("12pm"), lunch_end: DateTime.parse("1pm"))
      appointment = create(:appointment, from: DateTime.parse("04 Jan 2021 09:00am"),
                                          to: DateTime.parse("04 Jan 2021 09:30am"),
                                          location: location)
      
      get location_find_slots_path(location), params: { daterange: "04 Jan 2021 - 06 Jan 2021" }

      expect(response.body).to include("04.01.2021 09:00 - 09:30")
      expect(response.body).to include("04.01.2021 12:00 - 13:00")
    end
  end
end