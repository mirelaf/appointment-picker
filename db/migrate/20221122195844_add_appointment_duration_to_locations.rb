class AddAppointmentDurationToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :appointment_duration_minutes, :integer
  end
end
