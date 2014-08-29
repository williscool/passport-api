class Boat < ActiveRecord::Base
  has_many :timeslots, through: :assignments
  #name and capacity come from db

  #a booking group cannot be split across different boats.

  #a boat can only be used for a single timeslot at any given time.

  def amount_booked_by_timeslot(timeslot) 
    self.assignments.where(timeslot: timeslot).first.booking.size
  end
end
