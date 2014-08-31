class AssignmentsController < ApplicationController
  def create
    @assignment = Assignment.create(timeslot: Timeslot.find(params[:assignment][:timeslot_id]), boat: Boat.find(params[:assignment][:boat_id]))   
    render json: @assignment
  end

  def index
    @assignments = Assignment.all
    render json: @assignments
  end
end
