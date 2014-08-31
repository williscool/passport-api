class Booking < ActiveRecord::Base
  # size comes from db

  # a booking group cannot be split across different boats.

  # you can have multiple bookings to a time slot
  # but they cant total more than the capcity of the boats assigned to this booking's timeslot
  before_validation :booking_size_avalible, on: :create

  after_validation :choose_boat, on: :create

  belongs_to :boat
  belongs_to :timeslot

  def booking_size_avalible
    if self.size <= 0
      errors.add(:size, "party size must be 1 or greater")
    end

    if self.timeslot.availability < self.size
      errors.add(:size, "this party size is too big for this time slot")
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


end
