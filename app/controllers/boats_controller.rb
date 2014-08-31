class BoatsController < ApplicationController
  def create
    @boat = Boat.create(capacity: params[:boat][:capacity], name: params[:boat][:name])   
    render json: @boat
  end

  def index
    @boats = Boat.all
    render json: @boats
  end
end
