class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])

    @start_date = Date.parse("2021-01-04") # hard-coded until made selectable / user-editable
    @end_date = Date.parse("2021-01-07") # hard-coded until made selectable / user-editable
    @appointments_already_booked = @location.appointments
                                            .where(from: @start_date.beginning_of_day..@end_date.end_of_day)
    @location_available_slots = @location.available_slots(@start_date, @end_date)
  end
end