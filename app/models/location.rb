class Location < ApplicationRecord
  validates_presence_of :day_start, :day_end, :lunch_start, :lunch_end
  validate :times_should_be_in_chronological_order

  private

  def times_should_be_in_chronological_order
    return unless day_start and day_end and lunch_start and lunch_end
    errors.add(:day_start, "must be before the end of the work day") unless day_start < day_end
    errors.add(:lunch_start, "must be before the end of the lunch block") unless lunch_start < lunch_end
    errors.add(:lunch_start, "must be during the work day") unless lunch_start > day_start and lunch_end < day_end
  end
end
