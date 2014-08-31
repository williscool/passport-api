require 'spec_helper'

describe BoatsController do
  describe "GET index" do
    it "assigns boats" do
      boat = FactoryGirl.create(:boat)
      get :index
      expect(assigns(:boats)).to eq([boat])
    end
  end

  describe "POST create" do
    it "assigns boat" do
      post :create, boat:{name:"titan", capacity: 8}
      expect(assigns(:boat).name).to eq("titan")
    end
  end
end
