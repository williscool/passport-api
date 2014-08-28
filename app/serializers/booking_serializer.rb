class BookingSerializer < ActiveModel::Serializer
  attributes :id, :size, :meta
  has_one :timeslot
end
