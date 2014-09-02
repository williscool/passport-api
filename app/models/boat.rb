class Boat < ActiveRecord::Base
  has_many :assignments
  has_many :timeslots, through: :assignments
  has_many :bookings

  #name and capacity come from db

  def availability_by_timeslot(ts)
      self.capacity - self.bookings_total_by_timeslot(ts)
  end

  def bookings_total_by_timeslot(ts)
    Booking.where(timeslot:ts, boat:self).sum(:size) 
  end

end
