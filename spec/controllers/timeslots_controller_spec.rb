require 'spec_helper'

describe TimeslotsController do

  describe "GET index" do
    it "assigns timeslots" do
      ts = FactoryGirl.create(:timeslot)
      get :index
      expect(assigns(:timeslots)).to eq([ts])
    end

    it "works with date param" do
      date_string = "2014-08-27"
      time = date_string.to_date + 6.hours

      ts = FactoryGirl.create(:timeslot, start_time: time )
      get :index, date: date_string
      expect(assigns(:timeslots)).to eq([ts])
    end
  end

end
