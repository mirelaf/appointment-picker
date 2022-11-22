class Location < ApplicationRecord
  validates_presence_of :day_start, :day_end, :lunch_start, :lunch_end
end
