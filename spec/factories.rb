FactoryGirl.define do

  factory :timeslot do
  end

  factory :boat do
    sequence(:name) { |n| "Boat #{n}" }
  end

  factory :assignment do
  end

  factory :booking do
  end

end
