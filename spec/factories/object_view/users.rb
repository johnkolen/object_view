FactoryBot.define do
  factory :user do
    email { 'user@test.com' }
    role_id { User::RoleNone }
    password { "xyzzy!" }
  end
  trait :admin do
    before(:create) do
      role_id { User::AdminRole }
    end
  end
  trait :student do
    before(:create) do
      role_id { User::StudentRole }
    end
  end
end
