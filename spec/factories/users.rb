FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    provider { "google_oauth2" }
    sequence(:uid) { |n| "google_uid_#{n}" }
    avatar { nil }

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_avatar.jpg'), 'image/jpeg') }
    end
  end
end
