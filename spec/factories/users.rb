FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    prefecture_code { '13' }
    describe { 'テストユーザーです' }
    association :roaster
  end
end
