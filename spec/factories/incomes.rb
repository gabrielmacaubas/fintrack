FactoryBot.define do
  factory :income do
    association :user
    association :category
    amount { "9.99" }
    date { "2025-08-25" }
    description { "MyText" }
    receipt_file { "MyString" }
  end
end


