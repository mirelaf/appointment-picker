class Location < ApplicationRecord
  has_many :appointments

  validates_presence_of :day_start, :day_end, :lunch_start, :lunch_end, :appointment_duration_minutes
  validate :times_should_be_in_chronological_order
  
  def available_slots(start_date, end_date)
    available_slots = []
  
    (start_date..end_date).to_a.each do |day|
      slot_start = parse_time(day, day_start)
      day_end_time = parse_time(day, day_end)
      day_unavailable_periods = []
  
      # select the already booked appointments for the day
      appointments.select { |appointment| appointment.from.to_date == day}.each do |appointment|
        day_unavailable_periods << { from: appointment.from, to: appointment.to }
      end

      # include the lunch break as unavailable slot, too
      day_unavailable_periods << { from: parse_time(day, lunch_start), to: parse_time(day, lunch_end) }
      # sort by the "from" so that the unavailable periods are ordered chronologically
      day_unavailable_periods.sort_by! { |period| period[:from] }

      while slot_start < day_end_time do
        slot_end = slot_start + appointment_duration_minutes.minutes

        # find the next unavailable period for the day
        next_unavailable_period = day_unavailable_periods.select { |period| period[:from] >= slot_start }.first

        if next_unavailable_period.nil? # nice, the rest of the day is free!
          available_slots << { from: slot_start, to: slot_end } if slot_end <= day_end_time 
          slot_start = slot_end
        else 
          unless next_unavailable_period[:from] < slot_end && slot_start < next_unavailable_period[:to] # the slot overlaps an unavailable period
            available_slots << { from: slot_start, to: slot_end } if slot_end <= day_end_time 
            slot_start = slot_end
          else # start at the end of the unanavailable period, and if during lunch time, after lunch time
            slot_start = next_unavailable_period[:to].between?(parse_time(day, lunch_start), parse_time(day, lunch_end)) ? parse_time(day, lunch_end) : next_unavailable_period[:to]
          end
        end
      end
    end

    available_slots
  end

  def parse_time(day, time)
    DateTime.parse("#{day} #{time}")
  end

  private

  def times_should_be_in_chronological_order
    return unless day_start and day_end and lunch_start and lunch_end
    errors.add(:day_start, "must be before the end of the work day") unless day_start < day_end
    errors.add(:lunch_start, "must be before the end of the lunch block") unless lunch_start < lunch_end
    errors.add(:lunch_start, "must be during the work day") unless lunch_start > day_start and lunch_end < day_end
  end
end
