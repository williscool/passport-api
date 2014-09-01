class BookingSerializer < ActiveModel::Serializer
  attributes :id, :size
  has_one :timeslot
end
