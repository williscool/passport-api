require 'spec_helper'

describe Assignment do
  xit "wont happen unless boat time assignment doesnt conflict" do
    ts = FactoryGirl.create(:timeslot, start_time: Time.now, duration: 30)
    ts_conflict = FactoryGirl.create(:timeslot, start_time: Time.now + 10.minutes, duration: 30)
    
    big_boat = ts.boats.create(name:"titan", capacity: 10)

    
    expect(big_boat.assignments.create(timeslot: ts_conflict)).errors_on(:timeslot).to eq("test")
  end
end
