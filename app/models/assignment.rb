class Assignment < ActiveRecord::Base
  belongs_to :timeslot 
  belongs_to :boat

  validates :boat, :uniqueness => { :scope => :timeslot,
    :message => "this boat is already associated with this timeslot." }
  # but multiple boats can be assigned to a timeslot

  validate :check_timeslot_conflict

   def check_timeslot_conflict
     # slowish

     # so given test case 2 from the client
     #
     # the teams opinion of what should happen in a conflict was different than my original one
     # I was of the mind that if the boat was already booked for a conflicting time we just kick it out as a matter of course
     #
     # the team says its fine as long as no one has booked the boat for any conflicting slot of time already
     #
     # once its booked the boat is removed from the conflicting slots and only left on the first slot an actual reservation was made to

     if self.boat.bookings.count == 0
       return true # boat isnt booked period so we can just add timeslot
     else
       #boat has bookings lets look for a conflict

       bat = Booking.arel_table
       tsat = Timeslot.arel_table

       # only want to look at timeslots with bookings
       boat_timeslots_with_bookings = self.boat.timeslots.joins(:bookings).having(bat[:id].count.gt(0)).group(tsat[:id])

       if boat_timeslots_with_bookings.count == 0
         return true # no timeslot with a booking boat can be added
       end

       #there is a booking lets check for a conflict
       boat_timeslots_with_bookings.each do |ts|

         if Assignment.overlap(ts.start_time...ts.end_time, self.timeslot.start_time...self.timeslot.end_time)
           errors.add(:timeslot, "this time conflicts with another time this boat is booked for")
         end
       end

       # if there was no conflicting time boat will have been assigned to this slot now
     end

   end

   def self.overlap(x,y) 
     # this should totally be a core function
     # http://stackoverflow.com/a/699479/511710
     #
     # relies on the collections you are comparing to be sorted in ascending order already 
     # but the time ranges we will give it always will be anyway

    (x.first <= y.last) and (y.first <= x.last)
   end
end
