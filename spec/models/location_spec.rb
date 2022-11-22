require "rails_helper"

RSpec.describe Location, type: :model do
  context 'validations' do
    subject {
      described_class.new(day_start: Time.now - 6.hours,
                          day_end: Time.now + 4.hours,
                          lunch_start: Time.now - 3.hours,
                          lunch_end: Time.now - 2.hours
                        )
    }

    it { should validate_presence_of(:day_start) }
    it { should validate_presence_of(:day_end) }
    it { should validate_presence_of(:lunch_start) }
    it { should validate_presence_of(:lunch_end) }
  end
end