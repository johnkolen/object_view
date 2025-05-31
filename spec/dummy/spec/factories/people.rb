FactoryBot.define do
  factory :person do
    name { "Joe Black" }
    date_of_birth { Date.today - 30.years - 1.day }
    ssn { "123-45-6789" }
    age { 30 }
  end

  factory :person_sample do
    name { Faker::Name.full_name }
    transient do
      yold { 18 + rand(20) }
    end
    date_of_birth { Date.today - yold.years - rand(365).days }
    ssn { "%03d-%02d-%04d" % [rand(1000), rand(100), rand(10000)] }
    age { yold }
  end

  trait :with_person do
    after(:create) do |obj|
      create(:person_sample, person_id: obj.id)
    end
  end
end
