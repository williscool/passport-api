class Booking < ActiveRecord::Base
  # size comes from db

  # a booking group cannot be split across different boats.

  # you can have multiple bookings to a time slot
  # but they cant total more than the capcity of the boats assigned to this booking's timeslot
  before_validation :booking_size_avalible, on: :create

  belongs_to :boat
  belongs_to :timeslot

  def booking_size_avalible
    if self.size <= 0
      errors.add(:size, "party size must be 1 or greater")
    end

    if self.timeslot.availability < self.size
      errors.add(:size, "this party size is too big for this time slot")
    end
  end

end
