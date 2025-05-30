FactoryBot.define do
  factory :phone_number do
    number { "(123)456-7890" }
    active { true }
    person
  end
  factory :phone_number_sample do
    number { "(%3d)%3d-%4d" % [100 + rand(900), 100 + rand(900), rand(10000)] }
    active { true }
    person
  end
  trait :with_phone_number do
    after(:create) do |person|
      create(:phone_number_sample, person_id: person.id)
    end
  end
end
