FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name { "Doe" }
    sequence(:username) { |n| "john_doe_#{n}" }
    sequence(:email) { |n| "john_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    active { true }
  end
end
