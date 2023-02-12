FactoryBot.define do
  factory :roaster do
    name { 'テストロースター' }
    phone_number { '0123456789' }
    prefecture_code { '13' }
    address { '**区**丁目**-**' }
    describe { 'テストロースターです' }

    trait :with_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg') }
    end

    trait :guest do
      guest { true }
    end

    trait :invalid do
      name { nil }
    end

    trait :update do
      name { 'アップデートロースター' }
    end

    trait :at_where do
      name { 'どこかのロースター' }
      prefecture_code { '1' }
    end

  end
end
