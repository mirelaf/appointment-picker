class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
  end

  def find_slots
    @location = Location.find(params[:id])
    @start_date = params[:daterange].present? ? Date.parse(params[:daterange].split("-").first.strip) : Date.parse("2021-01-04")
    @end_date = params[:daterange].present? ? Date.parse(params[:daterange].split("-").last.strip) : Date.parse("2021-01-07")
    @unavailable_slots = @location.unavailable_slots(@start_date, @end_date)
    @available_slots = @location.available_slots(@start_date, @end_date)
    
    render 'show'
  end
end