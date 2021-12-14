FactoryBot.define do
  factory :roaster do
    name { 'テストロースター' }
    phone_number { '0123456789' }
    prefecture_code { '13' }
    address { '**区**丁目**-**' }
    describe { 'テストロースターです' }
  end
end
