require "rails_helper"

RSpec.describe Location, type: :model do
  context 'validations' do
    subject {
      described_class.new(day_start: DateTime.now - 6.hours,
                          day_end: DateTime.now + 4.hours,
                          lunch_start: DateTime.now - 3.hours,
                          lunch_end: DateTime.now - 2.hours,
                          appointment_duration_minutes: 30)
    }

    it { should validate_presence_of(:day_start) }
    it { should validate_presence_of(:day_end) }
    it { should validate_presence_of(:lunch_start) }
    it { should validate_presence_of(:lunch_end) }
    it { should validate_presence_of(:appointment_duration_minutes) }

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

  context 'relations' do
    it { is_expected.to have_many(:appointments) }
  end

  describe '#available_slots' do
    let(:location) { create(:location,
      day_start: DateTime.parse("8am"),
      day_end: DateTime.parse("18pm"),
      lunch_start: DateTime.parse("12pm"),
      lunch_end: DateTime.parse("1pm"),
      appointment_duration_minutes: 30)
    }

    context 'when there are no other appointments booked for the day' do
      it 'starts the next possible slot at the beginning of the day' do
        expected_slots = location.available_slots(Date.today, Date.today)
        expected_next_slot_start = expected_slots.first[:from] unless expected_slots.first.nil?

        expect(expected_next_slot_start).to eq(location.day_start)
      end
    end

    context 'when there are multiple booked slots during a day' do
      let(:existing_appointment1) { create(:appointment,
        location_id: location.id,
        from: DateTime.parse("10am"),
        to: DateTime.parse("11:30am"))
      }

      let(:existing_appointment2) { create(:appointment,
        location_id: location.id,
        from: DateTime.parse("2pm"),
        to: DateTime.parse("4pm"))
      }

      let(:existing_appointment3) { create(:appointment,
        location_id: location.id,
        from: DateTime.parse("5pm"),
        to: DateTime.parse("5:30pm"))
      }

      it 'finds convenient slots around all of them and around the lunch break' do
        existing_appointment1.reload
        existing_appointment2.reload
        existing_appointment3.reload
        expected_slots = location.available_slots(Date.today, Date.today)

        expect(expected_slots).to eq([
          { from: DateTime.parse("8:00am"), to: DateTime.parse("8:30am")},
          { from: DateTime.parse("8:30am"), to: DateTime.parse("9:00am")},
          { from: DateTime.parse("9:00am"), to: DateTime.parse("9:30am")},
          { from: DateTime.parse("9:30am"), to: DateTime.parse("10:00am")},
          { from: DateTime.parse("11:30am"), to: DateTime.parse("12:00pm")},
          { from: DateTime.parse("1:00pm"), to: DateTime.parse("1:30pm")},
          { from: DateTime.parse("1:30pm"), to: DateTime.parse("2:00pm")},
          { from: DateTime.parse("4:00pm"), to: DateTime.parse("4:30pm")},
          { from: DateTime.parse("4:30pm"), to: DateTime.parse("5:00pm")},
          { from: DateTime.parse("5:30pm"), to: DateTime.parse("6:00pm")}
        ])
      end
    end

    context 'when a booked appointment is before lunch' do
      context 'and there is enough time for an appointment before lunch' do
        let(:existing_appointment_start) { DateTime.parse("8am") }
        let(:existing_appointment_end) { DateTime.parse("10:30am") }
        let(:existing_appointment) { create(:appointment,
          location_id: location.id,
          from: existing_appointment_start,
          to: existing_appointment_end)
        }

        it 'starts the next possible slot at the end of the booked appartment' do
          existing_appointment.reload
          expected_slots = location.available_slots(Date.today, Date.today)
          expected_next_slot_start = expected_slots.first[:from] unless expected_slots.first.nil?

          expect(expected_next_slot_start).to eq(existing_appointment_end)
        end
      end

      context 'and there is not enough time for an appointment before lunch' do
        let(:existing_appointment_start) { DateTime.parse("8am") }
        let(:existing_appointment_end) { DateTime.parse("11:45am") }
        let(:existing_appointment) { create(:appointment,
          location_id: location.id,
          from: existing_appointment_start,
          to: existing_appointment_end)
        }

        it 'starts the next possible slot after lunch' do
          existing_appointment.reload
          expected_slots = location.available_slots(Date.today, Date.today)
          expected_next_slot_start = expected_slots.first[:from] unless expected_slots.first.nil?

          expect(expected_next_slot_start).to eq(DateTime.parse("#{Date.today} #{location.lunch_end}"))
        end
      end
    end

    context 'when a booked appointment is overlapping lunch' do
      context 'and it finishes before the lunch break is over' do
        let(:existing_appointment_start) { DateTime.parse("8am") }
        let(:existing_appointment_end) { DateTime.parse("12:15pm") }
        let(:existing_appointment) { create(:appointment,
          location_id: location.id,
          from: existing_appointment_start,
          to: existing_appointment_end)
        }

        it 'starts the next possible slot after lunch' do
          existing_appointment.reload
          expected_slots = location.available_slots(Date.today, Date.today)
          expected_next_slot_start = expected_slots.first[:from] unless expected_slots.first.nil?

          expect(expected_next_slot_start).to eq(DateTime.parse("#{Date.today} #{location.lunch_end}"))
        end
      end

      context 'and it finishes after the lunch break is over' do
        let(:existing_appointment_start) { DateTime.parse("8am") }
        let(:existing_appointment_end) { DateTime.parse("1:15pm") }
        let(:existing_appointment) { create(:appointment,
          location_id: location.id,
          from: existing_appointment_start,
          to: existing_appointment_end)
        }

        it 'starts the next possible slot at the end of the booked appointment' do
          existing_appointment.reload
          expected_slots = location.available_slots(Date.today, Date.today)
          expected_next_slot_start = expected_slots.first[:from] unless expected_slots.first.nil?

          expect(expected_next_slot_start).to eq(existing_appointment_end)
        end
      end
    end

    context 'when a booked appointment is after lunch' do
      context 'and there is enough time after it for a possible slot before day end' do
        let(:existing_appointment_start) { DateTime.parse("8am") }
        let(:existing_appointment_end) { DateTime.parse("3pm") }
        let(:existing_appointment) { create(:appointment,
          location_id: location.id,
          from: existing_appointment_start,
          to: existing_appointment_end)
        }

        it 'starts the next possible slot at the end of the booked appointment' do
          existing_appointment.reload
          expected_slots = location.available_slots(Date.today, Date.today)
          expected_next_slot_start = expected_slots.first[:from] unless expected_slots.first.nil?

          expect(expected_next_slot_start).to eq(existing_appointment_end)
        end
      end

      context 'and there is not enough time after it for a possible slot before day end' do
        let(:existing_appointment_start) { DateTime.parse("8am") }
        let(:existing_appointment_end) { DateTime.parse("5:45pm") }
        let(:existing_appointment) { create(:appointment,
          location_id: location.id,
          from: existing_appointment_start,
          to: existing_appointment_end)
        }

        it 'does not identify any more possible slots for that day' do
          existing_appointment.reload
          expected_slots = location.available_slots(Date.today, Date.today)
          expected_next_slot_start = expected_slots.first[:from] unless expected_slots.first.nil?

          expect(expected_slots.size).to eq(0)
          expect(expected_next_slot_start).to be_nil
        end
      end
    end
  end
end