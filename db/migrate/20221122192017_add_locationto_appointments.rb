class AddLocationtoAppointments < ActiveRecord::Migration[6.0]
  def change
    add_reference :appointments, :location, index: true, foreign_key: true
  end
end
