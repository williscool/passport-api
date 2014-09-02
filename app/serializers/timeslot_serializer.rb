class TimeslotSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :duration, :availability, :customer_count

  def start_time
    object.start_time.to_i
  end

  has_many :boats
end
