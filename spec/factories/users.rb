FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test1@example.com' }
    password = 'password'
    password { password }
    password_confirmation { password }
    prefecture_code { '13' }
    describe { 'テストユーザーです' }
    association :roaster
  end
end
