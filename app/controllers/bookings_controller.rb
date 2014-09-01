class BookingsController < ApplicationController
  def create
    @timeslot = Timeslot.find(params[:booking][:timeslot_id])
    @booking = Booking.create(timeslot: @timeslot, size: params[:booking][:size])

    render json: BookingSerializer.new(@booking, root:false)
  end

  def index
    @bookings = Booking.all
    render json: ActiveModel::ArraySerializer.new(@bookings, each_serializer: BookingSerializer)
  end

  def show
    @booking = Timeslot.find(params[:id])
    render json: BookingSerializer.new(@boat, root:false)
  end
end
