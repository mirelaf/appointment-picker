FactoryBot.define do
  factory :appointment do
  	from { DateTime.parse("10am") }
  	to { DateTime.parse("10:30am") }

    association :location
  end
end
