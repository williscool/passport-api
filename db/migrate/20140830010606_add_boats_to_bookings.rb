class AddBoatsToBookings < ActiveRecord::Migration
  def change
    add_reference :bookings, :boat, index: true
  end
end
