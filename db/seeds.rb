# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Location.create(day_start: DateTime.parse("8am"),
                day_end: DateTime.parse("18pm"),
                lunch_start: DateTime.parse("12pm"),
                lunch_end: DateTime.parse("1pm"),
                appointment_duration_minutes: 30)

WEEKLY_APPOINTMENTS = [
  { from: "2021-01-04T10:15:00", to: "2021-01-04T10:30:00" },
  { from: "2021-01-05T11:00:00", to: "2021-01-05T11:30:00" },
  { from: "2021-01-05T15:30:00", to: "2021-01-05T16:30:00" },
  { from: "2021-01-06T10:00:00", to: "2021-01-06T10:30:00" },
  { from: "2021-01-06T11:00:00", to: "2021-01-06T12:30:00" },
  { from: "2021-01-06T17:30:00", to: "2021-01-06T18:00:00" },
]

WEEKLY_APPOINTMENTS.each do |period|
  Appointment.create(from: DateTime.parse(period[:from]),
                    to: DateTime.parse(period[:to]),
                    location: Location.first)
end