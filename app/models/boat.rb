class Boat < ActiveRecord::Base
  has_many :assignments
  has_many :timeslots, through: :assignments
  has_many :bookings

  #name and capacity come from db

end
