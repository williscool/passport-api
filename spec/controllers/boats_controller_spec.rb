require 'spec_helper'

describe BoatsController do
    it "assigns timeslots" do
      boat = FactoryGirl.create(:boat)
      get :index
      expect(assigns(:boats)).to eq([boat])
    end

    it "assigns timeslot" do
      post :create, name:"titan", capacity: 8
      expect(assigns(:boat).name).to eq("titan")
    end
end
