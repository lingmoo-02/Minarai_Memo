FactoryBot.define do
  factory :team_membership do
    association :team
    association :user
    role { :apprentice }

    trait :master do
      role { :master }
    end

    trait :owner do
      role { :owner }
    end
  end
end
