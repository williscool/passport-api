class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :meta
  has_one :timeslot
  has_one :boat
end
