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

  describe "conflict resolution" do
    it "removes boats from conflicting timeslots" do
      ts1 = FactoryGirl.create(:timeslot, start_time:Time.now, duration:1.hour)
      ts2 = FactoryGirl.create(:timeslot, start_time:Time.now + 30.minutes, duration:1.hour)
      ts3 = FactoryGirl.create(:timeslot, start_time:Time.now - 30.minutes, duration:1.hour)
      
      small_boat = ts1.boats.create(name:"titan", capacity: 8)
      ts2.assignments.create(boat:small_boat)
      ts3.assignments.create(boat:small_boat)

      expect(ts1.availability).to eq(8)
      expect(ts2.availability).to eq(8)
      expect(ts3.availability).to eq(8)

      ts2.bookings.create(size: 2, boat: small_boat)

      # sad face at having to reload to models. you would think they would do that to themselves
      # but then again the removal happens in the db which is what they are loaded from so its not completly retarded
      
      ts1.reload
      ts2.reload
      ts3.reload

      expect(ts1.availability).to eq(0)
      expect(ts3.availability).to eq(0)
      expect(ts2.availability).to eq(6)
    end

    it "wont add booking to boat with a booking from conflicting timeslot" do
      ts1 = FactoryGirl.create(:timeslot, start_time:Time.now, duration:1.hour)
      ts2 = FactoryGirl.create(:timeslot, start_time:Time.now + 30.minutes, duration:1.hour)
      
      small_boat = ts1.boats.create(name:"money", capacity: 8)

      ts1.bookings.create(size: 2)
      expect(ts1.availability).to eq(6)

      assignment = ts2.assignments.create(boat:small_boat)

      booking = ts2.bookings.create(size: 2)

      expect(ts2.availability).to eq(0)

    end
  end
end
