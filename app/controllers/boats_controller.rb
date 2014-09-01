class BoatsController < ApplicationController
  def create
    @boat = Boat.create(capacity: params[:boat][:capacity], name: params[:boat][:name])   
    render json: BoatSerializer.new(@boat)
  end

  def index
    @boats = Boat.all
    render json: ActiveModel::ArraySerializer.new(@boats, each_serializer: BoatSerializer)
  end
end
