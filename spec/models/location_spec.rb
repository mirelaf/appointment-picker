require "rails_helper"

RSpec.describe Location, type: :model do
  context 'validations' do
    subject {
      described_class.new(day_start: DateTime.now - 6.hours,
                          day_end: DateTime.now + 4.hours,
                          lunch_start: DateTime.now - 3.hours,
                          lunch_end: DateTime.now - 2.hours
                        )
    }

    it { should validate_presence_of(:day_start) }
    it { should validate_presence_of(:day_end) }
    it { should validate_presence_of(:lunch_start) }
    it { should validate_presence_of(:lunch_end) }

    describe '#times_should_be_in_chronological_order' do
      it "is valid when 'day_start', 'lunch_start', 'lunch_end', 'day_end' are in chronological order" do
        expect(subject).to be_valid
      end

      it "is not valid when 'day_start' is after 'day_start'" do
        subject.day_start = DateTime.now + 5.hours
        expect(subject).to_not be_valid
      end

      it "is not valid when 'lunch_start' is after 'lunch_end'" do
        subject.lunch_start = DateTime.now - 1.hour
        expect(subject).to_not be_valid
      end

      it "is not valid when 'lunch_start' is before 'day_start'" do
        subject.lunch_start = DateTime.now - 7.hours
        expect(subject).to_not be_valid
      end

      it "is not valid when 'lunch_end' is after 'day_end'" do
        subject.lunch_end = DateTime.now + 5.hours
        expect(subject).to_not be_valid
      end    
    end
  end
end