class Assignment < ActiveRecord::Base
  belongs_to :timeslot 
  belongs_to :boat

  # should have a validation here that boat isn't already assigned to a conflicting timeslot
    #  algorithm for that
    #  
    #  when trying to assign boat to timeslot:
    #   - go through each time and see if its range overlaps with another the boat is on
    #   -  http://www.ruby-doc.org/core-1.9.3/Range.html#method-i-cover-3F
    #   - http://stackoverflow.com/questions/4521921/how-to-know-if-todays-date-is-in-a-date-range/11671185#11671185
    #   - fail validation if so
end
