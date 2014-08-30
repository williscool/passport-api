class TimeslotsController < ApplicationController
  def create
    @timeslot = Timeslot.create(start_time: params[:start_time], duration: params[:duration])   
    render json: @timeslot
  end

  def index
    
    if params[:date].present?
      @day = params[:date].to_date
      @timeslots = Timeslot.where(start_time: @day.beginning_of_day..@day.end_of_day)
    else
      @timeslots = Timeslot.all 
    end

    render json: @timeslots
  end
end
