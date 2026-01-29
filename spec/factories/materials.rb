FactoryBot.define do
  factory :material do
    sequence(:name) { |n| "資材#{n}" }
    user { nil }
    team { nil }

    trait :personal do
      association :user
      team { nil }
    end

    trait :team_material do
      association :team
      user { nil }
    end
  end
end
