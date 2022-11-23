class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])

    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.parse("2021-01-04")
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.parse("2021-01-07")
    @unavailable_slots = @location.unavailable_slots(@start_date, @end_date)
    @available_slots = @location.available_slots(@start_date, @end_date)
  end
end