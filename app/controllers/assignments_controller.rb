class AssignmentsController < ApplicationController
  def create
    @assignment = Assignment.create(timeslot: Timeslot.find(params[:assignment][:timeslot_id]), boat: Boat.find(params[:assignment][:boat_id]))   
    render json: AssignmentSerializer.new(@assignment, root:false)
  end

  def index
    @assignments = Assignment.all
    render json: ActiveModel::ArraySerializer.new(@assignments, each_serializer: AssignmentSerializer)
  end
end
