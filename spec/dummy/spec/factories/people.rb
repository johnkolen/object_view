require "faker"

FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    date_of_birth { Date.today - 30.years - 1.day }
    ssn { "123-45-6789" }
    age { 30 }
    happy { true }

    factory :person_sample do
      transient do
        yold { 18 + rand(20) }
      end
      name { Faker::Name.name }
      date_of_birth { Date.today - yold.years - rand(365).days }
      ssn { "%03d-%02d-%04d" % [ rand(1000), rand(100), rand(10000) ] }
      age { yold }
      happy { rand(2) == 1 }
    end
  end
end
