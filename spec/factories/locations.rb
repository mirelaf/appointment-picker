FactoryBot.define do
  factory :location do
  	day_start { DateTime.parse("8am") }
  	day_end { DateTime.parse("18pm") }
    lunch_start { DateTime.parse("12pm") }
    lunch_end { DateTime.parse("1pm") }
    appointment_duration_minutes { 30 }
  end
end
