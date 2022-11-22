class Appointment < ApplicationRecord
  validates :from, presence: true
  validates :to, presence: true
  validate :from_must_be_before_to
  validate :same_day
  
  private

  def from_must_be_before_to
    return unless from and to
    errors.add(:from, "must be before to time") unless from < to
  end

  def same_day
    return unless from and to
    errors.add(:from, "must in same day as to time") unless from.to_date == to.to_date
  end
end
