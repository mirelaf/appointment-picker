class Appointment < ApplicationRecord
  validates :from, presence: true
  validates :to, presence: true
  validate :from_must_be_before_to
  
  private

  def from_must_be_before_to
    return unless from and to
    errors.add(:from, "must be before to time") unless from < to
  end 
end
