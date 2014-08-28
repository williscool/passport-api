class TimeslotSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :duration, :meta
end
