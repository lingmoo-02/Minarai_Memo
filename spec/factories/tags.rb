FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "タグ#{n}" }
    team { nil }

    trait :team_tag do
      association :team
    end
  end
end
