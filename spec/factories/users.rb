FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    prefecture_code { '13' }
    describe { 'テストユーザーです' }
    association :roaster

    trait :with_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg') }
    end
  end
end
