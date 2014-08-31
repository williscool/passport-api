require 'spec_helper'

describe Booking do

  it "can only be done when there is enough timeslot availability" do 
      timeslot = FactoryGirl.create(:timeslot)
      big_boat = timeslot.boats.create(name:"titan", capacity: 10)
      small_boat = timeslot.boats.create(name:"lil b", capacity: 6)

      timeslot.bookings.create(boat: big_boat, size:7)
      booking = timeslot.bookings.create(boat: small_boat, size:22)

      expect(booking).to have(1).errors_on(:size)
  end

  it "size must be greater than zero" do 
      timeslot = FactoryGirl.create(:timeslot)
      small_boat = timeslot.boats.create(name:"titan", capacity: 10)

      booking_neg = timeslot.bookings.create(boat: small_boat, size:-1)
      booking_zero = timeslot.bookings.create(boat: small_boat, size:0)

      expect(booking_neg).to have(1).errors_on(:size)
      expect(booking_zero).to have(1).errors_on(:size)
  end

  describe "picks boat with smallest availability that will fit" do 

    it "corectly with no prior bookings" do
      timeslot = FactoryGirl.create(:timeslot)

      small_boat = timeslot.boats.create(name:"titan", capacity: 5)
      big_boat = timeslot.boats.create(name:"titan", capacity: 10)
      medium_boat = timeslot.boats.create(name:"titan", capacity: 7)

      timeslot.assignments.create(boat:small_boat)
      timeslot.assignments.create(boat:big_boat)
      timeslot.assignments.create(boat:medium_boat)

      timeslot.bookings.create(size:7)

      expect(timeslot.bookings.first.boat).to eq(medium_boat)
    end

    it "corectly with one prior booking" do
      timeslot = FactoryGirl.create(:timeslot)

      small_boat = timeslot.boats.create(name:"titan", capacity: 5)
      big_boat = timeslot.boats.create(name:"titan", capacity: 10)
      medium_boat = timeslot.boats.create(name:"titan", capacity: 8)

      timeslot.assignments.create(boat:small_boat)
      timeslot.assignments.create(boat:big_boat)
      timeslot.assignments.create(boat:medium_boat)

      timeslot.bookings.create(size:7)
      timeslot.bookings.create(size:7)

      expect(timeslot.bookings.first.boat).to eq(medium_boat)
      expect(timeslot.bookings.last.boat).to eq(big_boat)
    end
  end
end
