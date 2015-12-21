FactoryGirl.define do
  factory :attendance_event do
    student
    event_date Faker::Time.between(DateTime.now - 100, DateTime.now)
    absence false
    tardy false
    trait :absence do
      absence true
    end
    trait :tardy do
      tardy true
    end
    trait :in_january_2015 do
      event_date Time.new(2015, 1, 1)
    end
  end
end
