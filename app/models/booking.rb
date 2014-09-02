class Booking < ActiveRecord::Base
  # size comes from db

  # a booking group cannot be split across different boats.

  # you can have multiple bookings to a time slot
  # but they cant total more than the capcity of the boats assigned to this booking's timeslot

  validate :booking_size_or_time_avalible

  after_validation :choose_boat, on: :create
  after_validation :check_booking_conflict, on: :create

  belongs_to :boat
  belongs_to :timeslot

  def booking_size_or_time_avalible

    if self.size <= 0
      errors.add(:size, "party size must be 1 or greater")
      return false
    end

    if self.timeslot.boats.count < 1
      errors.add(:timeslot, "has no boats availible")
      return false
    end

    if self.timeslot.availability < self.size
      errors.add(:size, "this party size is too big for this time slot")
      return false
    end

  end

  def choose_boat
    return if self.boat.present? # boat was set already
    # naive and slow :(
    
    bat = Boat.arel_table

    if self.timeslot.boats.count <= 0
      errors.add(:boat, "there are no boats assigned to this time slot")
      return
    end
    
    # pick the smallest boat they will fit on that is big enough to fit on 
    boats_big_enough = self.timeslot.boats.where(bat[:capacity].gteq(self.size)).order(bat[:capacity].asc)
    
    if boats_big_enough.count <= 0
      errors.add(:boat, "There are no boats assigned to this time big enough to fit this party")
      return
    end

    # and has smallest availability that will fit
    boats_with_avail = boats_big_enough.collect{|b| [b,b.availability_by_timeslot(self.timeslot)] }

    # this craziness so we dont have to ask all the boats their availability again
    boats_collection_with_enough_space = boats_with_avail.select{|bwa| self.size <= bwa[1]}

    #do this so first boat in collection will be one with smallest space
    boats_collection_sort_by_avail = boats_collection_with_enough_space.sort_by{|bwa| bwa[1] }

    boats_in_order = boats_collection_sort_by_avail.collect{|bwa| bwa[0]}

    if boats_in_order.blank? 
      errors.add(:boat, "There are no boats assigned to this time with enough opening for this party")
      return
    end

    boat_with_smallest_opening = boats_in_order.first

    self.boat = boat_with_smallest_opening
  end

  def check_booking_conflict
    #slow :(

    return false if self.boat.blank? # no boat :(

    boat_timeslots = self.boat.timeslots

    if boat_timeslots.count > 0 and (boat_timeslots.first == self.timeslot)
      return true #no other timeslots booking is a go
    else
      # check for conflict

      bat = Booking.arel_table
      tsat = Timeslot.arel_table
      
      boat_other_timeslots = self.boat.timeslots.where.not(id: self.timeslot.id) #because we want to compare other slots not this one

       if boat_other_timeslots.count == 0
         return true # no previous timeslots boat can be added
       end

       boat_timeslots_with_bookings = self.boat.timeslots.joins(:bookings).having(bat[:id].count.gt(0)).group(tsat[:id])

       if boat_timeslots_with_bookings.present? and boat_timeslots_with_bookings.include?(self.timeslot)
         # adding a booking a spot with a booking already so its cool
         return true 
       end

       conflicting_timeslots = []
       timeslots_with_conflicting_bookings = []

       boat_other_timeslots.each do |ts|
          
         if Assignment.overlap(ts.start_time...ts.end_time, self.timeslot.start_time...self.timeslot.end_time)
           conflicting_timeslots << ts
           if ts.bookings.count > 0
             timeslots_with_conflicting_bookings << ts
           end
         end
       end

       if timeslots_with_conflicting_bookings.blank?
         #1. we remove the boat from any conflicting slots
         conflicting_timeslots.each do |cts|
           cts.boats.destroy(self.boat) 
         end
         
         #2. we allow the booking to go through 
         return true 
       else
         # this booking would conflict with a booking on a conflicting timeslot
        errors.add(:timeslot, "this booking conflicts with another time this boat is booked for")
        # we could return timeslots_with_conflicting_bookings here also
       end

    end

  end

end
