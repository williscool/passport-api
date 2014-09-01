class BookingsController < ApplicationController
  def create
    @timeslot = Timeslot.find(params[:booking][:timeslot_id])
    @booking = Booking.create(timeslot: @timeslot, size: params[:booking][:size])

    render json: BookingSerializer.new(@booking)
  end

  def index
    @bookings = Booking.all
    render json: ActiveModel::ArraySerializer.new(@bookings, each_serializer: BookingSerializer)
  end

end
