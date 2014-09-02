require 'spec_helper'

describe Assignment do

  describe "conflict resolution" do
    it "will add boat to timeslot if a conflicting timeslot has no booking" do
      ts = FactoryGirl.create(:timeslot, start_time: Time.now, duration: 30)
      ts_conflict = FactoryGirl.create(:timeslot, start_time: Time.now + 10.minutes, duration: 30)
      
      big_boat = ts.boats.create(name:"titan", capacity: 10)

      ts_conflict.assignments.create(boat:big_boat)

      expect(big_boat.assignments.count).to eq(2)
    end

    it "wont add boat to timeslot if a conflicting timeslot has a booking" do
      ts = FactoryGirl.create(:timeslot, start_time: Time.now, duration: 30)
      ts_conflict = FactoryGirl.create(:timeslot, start_time: Time.now + 10.minutes, duration: 30)
      
      big_boat = ts.boats.create(name:"titan", capacity: 10)

      ts.bookings.create(size: 3)

      assignment = ts_conflict.assignments.create(boat:big_boat)

      expect(big_boat.assignments.count).to eq(1)
      expect(assignment.errors.count).to eq(1)
    end
  end
end
