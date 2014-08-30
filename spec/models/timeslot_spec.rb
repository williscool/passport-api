require 'spec_helper'

describe Timeslot do

  describe "availability" do

    it "returns 0 when no boats are associated" do
      timeslot = FactoryGirl.create(:timeslot)
      unassociated_boat = FactoryGirl.create(:boat)
      
      expect(timeslot.availability).to eq(0)
    end

    describe "gives correct count" do

      it "at all" do
        timeslot = FactoryGirl.create(:timeslot)
        timeslot.boats.create(name:"titan", capacity: 8)

        expect(timeslot.availability).to eq(8)
      end

      it "when a smaller boat than the largest has more available space" do
        timeslot = FactoryGirl.create(:timeslot)
        big_boat = timeslot.boats.create(name:"titan", capacity: 10)
        timeslot.boats.create(name:"lil b", capacity: 6)

        timeslot.bookings.create(boat: big_boat, size:7)

        expect(timeslot.availability).to eq(6)
      end

    end

  end

  it "customer count" do
      timeslot = FactoryGirl.create(:timeslot)
      big_boat = timeslot.boats.create(name:"titan", capacity: 10)
      small_boat = timeslot.boats.create(name:"lil b", capacity: 6)

      timeslot.bookings.create(boat: big_boat, size:7)
      timeslot.bookings.create(boat: small_boat, size:5)

      expect(timeslot.customer_count).to eq(12)
  end

end
