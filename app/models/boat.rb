class Boat < ActiveRecord::Base
  has_many :assignments
  has_many :timeslots, through: :assignments
  has_many :bookings

  #name and capacity come from db

  def availability_by_timeslot(ts)
      # naive and slow :(
     
      bookings_total = Booking.where(timeslot:ts, boat:self).sum(:size) 
      self.capacity - bookings_total
  end

end
