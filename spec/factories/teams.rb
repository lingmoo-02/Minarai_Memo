FactoryBot.define do
  factory :team do
    association :owner, factory: :user
    sequence(:name) { |n| "チーム#{n}" }
    description { Faker::Lorem.paragraph }
  end
end
