class AppointmentsController < ApplicationController
  def create
    @location = Location.find(params[:location_id])
    
    appointment = @location.appointments.build(appointment_params)

    if @location.save
      redirect_to controller: :locations, action: :find_slots,
        id: @location.id, daterange: params[:search_range]
    else
      redirect_to location_path(@location)
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:from, :to)
  end
end