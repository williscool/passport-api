class Assignment < ActiveRecord::Base
  belongs_to :timeslot 
  belongs_to :boat

  validates :boat, :uniqueness => { :scope => :timeslot,
    :message => "this boat is already associated with this timeslot." }

  validate :check_timeslot_conflict

  # but multiple boats can be assigned to a timeslot

  # validation that boat isn't already assigned to a conflicting timeslot
    #  algorithm for that
    #  
    #  when trying to assign boat to timeslot:
    #   - go through each time and see if its range overlaps with another the boat is on
    #   -  http://www.ruby-doc.org/core-1.9.3/Range.html#method-i-cover-3F
    #   - http://stackoverflow.com/questions/4521921/how-to-know-if-todays-date-is-in-a-date-range/11671185#11671185
    #   - fail validation if so
   def check_timeslot_conflict
     # nieve and slow :(

     self.boat.timeslots.each do |ts|
       start_time = ts.start_time
       end_time = ts.start_time + ts.duration.minutes
        
       if (start_time...end_time).cover?(self.timeslot.start_time)
         errors.add(:timeslot, "this time conflicts with another time this boat is booked for")
       end
     end

   end
end
