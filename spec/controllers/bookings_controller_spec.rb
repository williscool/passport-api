require 'spec_helper'

describe BookingsController do
  describe "GET index" do
    it "assigns bookings" do
      timeslot = FactoryGirl.create(:timeslot)
      small_boat = timeslot.boats.create(name:"titan", capacity: 10)

      book = timeslot.bookings.create(boat: small_boat, size:2)
      get :index
      expect(assigns(:bookings)).to eq([book])
    end
  end

  describe "POST create" do
    it "creates booking" do

      timeslot = FactoryGirl.create(:timeslot, duration: 30, start_time: Time.now + 3.hours)
      big_boat = timeslot.boats.create(name:"titan", capacity: 10)

      post :create, timeslot_id: timeslot.id, size: 2

      expect(timeslot.bookings.first.size).to eq(2)
      expect(timeslot.bookings.first.boat).to eq(big_boat)
    end
  end

end
