FactoryBot.define do
  factory :note do
    association :user
    title { Faker::Lorem.sentence(word_count: 5) }
    materials { "木材、釘、のこぎり" }
    work_duration { rand(30..480) }
    reflection { Faker::Lorem.paragraph(sentence_count: 3) }
    note_image { nil }

    trait :with_image do
      note_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_note_image.jpg'), 'image/jpeg') }
    end
  end
end
