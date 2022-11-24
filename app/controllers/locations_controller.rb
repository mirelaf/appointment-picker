class LocationsController < ApplicationController
  def index
    @locations = Location.all.order("id asc")
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])

    return redirect_to location_path(@location) if @location.update(location_params)

    render 'edit'
  end

  def show
    @location = Location.find(params[:id])
    @locations = Location.all.order("id asc")
  end

  def find_slots
    @location = Location.find(params[:id])
    @locations = Location.all

    @start_date = params[:daterange].present? ? Date.parse(params[:daterange].split("-").first.strip) : Date.parse("2021-01-04")
    @end_date = params[:daterange].present? ? Date.parse(params[:daterange].split("-").last.strip) : Date.parse("2021-01-07")

    @unavailable_slots = @location.unavailable_slots(@start_date, @end_date)
    @available_slots = @location.available_slots(@start_date, @end_date)
    
    render 'show'
  end

  private

  def location_params
    params.require(:location)
      .permit(:day_start, :day_end, :lunch_start,
              :lunch_end, :appointment_duration_minutes)
  end
end