class AssignmentsController < ApplicationController
  def create
    @assignment = Assignment.create(timeslot: Timeslot.find(params[:timeslot_id]), boat: Boat.find(params[:boat_id]))   
    render json: @assignment
  end

  def index
    @assignments = Assignment.all
    render json: @assignments
  end
end
