FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    uid { email }
    password { 'password' }
    prefecture_code { '13' }
    describe { 'テストユーザーです' }

    trait :with_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg') }
    end

    trait :invalid do
      name { nil }
    end

    trait :guest do
      guest { true }
    end

    trait :with_roaster do
      association :roaster
    end
  end
end
