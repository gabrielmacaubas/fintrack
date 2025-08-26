FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description { "My category description" }
    user { association :user }
  end
end


