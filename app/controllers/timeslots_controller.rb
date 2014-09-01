class TimeslotsController < ApplicationController
  include ActiveModel::Serialization

  def create
    @timeslot = Timeslot.create(start_time: Time.at(params[:timeslot][:start_time].to_i), duration: params[:timeslot][:duration])   
    render json: TimeslotSerializer.new(@timeslot, root:false)
  end

  def index
    
    if params[:date].present?
      @day = params[:date].to_date
      @timeslots = Timeslot.where(start_time: @day.beginning_of_day..@day.end_of_day)
    else
      @timeslots = Timeslot.all 
    end

    render json: ActiveModel::ArraySerializer.new(@timeslots, each_serializer: TimeslotSerializer)
  end

  def show
    @timeslot = Timeslot.find(params[:id])
    render json: TimeslotSerializer.new(@timeslot, root:false)
  end
end
