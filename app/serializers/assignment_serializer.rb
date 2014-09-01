class AssignmentSerializer < ActiveModel::Serializer
  attributes :id
  has_one :timeslot
  has_one :boat
end
