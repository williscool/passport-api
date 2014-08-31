require 'spec_helper'

describe AssignmentsController do

  describe "GET index" do
    it "assigns assignments" do
      timeslot = FactoryGirl.create(:timeslot, duration: 30, start_time: Time.now + 3.hours)
      big_boat = timeslot.boats.create(name:"titan", capacity: 10)

      timeslot.assignments.create(boat: big_boat)

      get :index
      expect(assigns(:assignments)).to eq([timeslot.assignments.first])
    end
  end

  describe "POST create" do
    it "assigns boat to timeslot" do
      timeslot = FactoryGirl.create(:timeslot, duration: 30, start_time: Time.now + 3.hours)
      big_boat = timeslot.boats.create(name:"titan", capacity: 10)

      ts_id = timeslot.id
      b_id = big_boat.id

      post :create, assignment: {timeslot_id: ts_id, boat_id: b_id}

      expect((timeslot.assignments.first).boat).to eq(big_boat)
    end
  end
end
