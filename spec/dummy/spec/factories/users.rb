FactoryBot.define do
  factory :user do
    email { "MyString" }

    after :build do |user|
      unless user.person_id
        user.person_id = create(:person).id
      end
    end
  end
end
