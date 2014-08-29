class Timeslot < ActiveRecord::Base
  has_many :boats, through: :assignments
  
  def availability
  # The availability is the maximum booking size of any new booking on this timeslot. 
    return 0 if self.assignments.blank? 

    avail = 0

    self.boats.each do |boat|
      # naive and slow :(
      
      cap = boat.capacity
      amt_booked = boat.amount_booked_by_timeslot(self) 
      
      avail_of_boat = cap - amt_booked

      avail = avail_of_boat if avail_of_boat > avail
    end

    avail
  end

  def customer_count
  # The customer count is the total number of customers booked for this timeslot.
    return 0 if self.boats.blank? or if self.bookings.blank? 

    self.bookings.collect(:size)
  end

  # boats come from db reference association
end
