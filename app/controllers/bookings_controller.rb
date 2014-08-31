class BookingsController < ApplicationController
  def create
    @timeslot = Timeslot.find(params[:timeslot_id])
    @booking = Booking.create(timeslot: @timeslot, size: params[:size])

    render json: @booking
  end

  def index
    @bookings = Booking.all
    render json: @bookings
  end

end
