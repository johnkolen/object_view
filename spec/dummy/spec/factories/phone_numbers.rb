FactoryBot.define do
  factory :phone_number do
    number { "MyString" }
    active { false }
    person { nil }
  end
end
