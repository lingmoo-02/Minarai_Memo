FactoryBot.define do
  factory :bookmark do
    association :user
    association :note
  end
end
