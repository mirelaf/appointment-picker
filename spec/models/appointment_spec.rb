require "rails_helper"

RSpec.describe Appointment, type: :model do
  context 'validations' do
    subject {
      described_class.new(from: DateTime.now,
                          to: DateTime.now + 2.hours,
                          location: Location.new)
    }

    it { should validate_presence_of(:from) }
    it { should validate_presence_of(:to) }

    describe '#from_must_be_before_to' do
      it "is valid when 'to' is after 'from'" do
        expect(subject).to be_valid
      end

      it "is not valid when 'to' is before 'from'" do
        subject.from = DateTime.now + 2.hours
        expect(subject).to_not be_valid
      end
    end

    describe '#same_day' do
      it "is not valid when 'from' and 'to' are in different dates" do
        subject.from = DateTime.new - 2.days
        expect(subject).to_not be_valid
      end
    end
  end

  context 'relations' do
    it { is_expected.to belong_to(:location) }
  end
end