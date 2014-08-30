class Booking < ActiveRecord::Base
  # size comes from db
  #a booking group cannot be split across different boats.

  # you can have multple bookings to a time slot but they cant total more than the capcity of the boat
  belongs_to :boat
  belongs_to :timeslot
end
