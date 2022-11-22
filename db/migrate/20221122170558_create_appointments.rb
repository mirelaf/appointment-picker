class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
  end
end