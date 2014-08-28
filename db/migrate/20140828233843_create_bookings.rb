class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :timeslot, index: true
      t.integer :size
      t.hstore :meta

      t.timestamps
    end
  end
end
