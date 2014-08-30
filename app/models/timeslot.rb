class Timeslot < ActiveRecord::Base
  has_many :assignments
  has_many :boats, through: :assignments

  has_many :bookings
  
  def availability
  # The availability is the maximum booking size of any new booking on this timeslot. 
    return 0 if self.assignments.blank? 

    avail = 0

    self.boats.each do |boat|
      # naive and slow :(
      
      booking = self.bookings.where(boat: boat).first

      amt_booked = 0 

      if booking.present?
        amt_booked = booking.size
      end
      
      avail_of_boat = boat.capacity - amt_booked

      avail = avail_of_boat if avail_of_boat > avail
    end

    avail
  end

  def customer_count
  # The customer count is the total number of customers booked for this timeslot.
    return 0 if self.boats.blank? or self.bookings.blank? 

    #self.bookings.collect(&:size).reduce(:+)
    
    Booking.where(timeslot:self).sum(:size)
  end

  # boats come from db reference association
end
