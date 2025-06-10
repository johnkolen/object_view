FactoryBot.define do
  factory :phone_number do
    number { "(123)456-7890" }
    active { true }
    person factory: :person

    factory :phone_number_sample do
      number { "(%3d)%3d-%04d" % [ 100 + rand(900), 100 + rand(900), rand(10000) ] }
      active { rand(2) == 1 }
      person factory: :person_sample
    end

    after :build do |phone_number|
      unless phone_number.person_id
        phone_number.person_id = create(:person).id
      end
    end
  end
end
