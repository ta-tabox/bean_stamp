FactoryBot.define do
  factory :bean do
    name { 'テストビーン' }
    country { 'エチオピア' }
    subregion { 'イルガチェフェ' }
    farm { 'テストファーム' }
    variety { 'アビシニカ' }
    elevation { '1500' }
    process { 'ナチュラル' }
    describe { 'テストコーヒー豆です' }
    cropped_at { '2021-01-01' }
    acidity { '3' }
    flavor { '3' }
    body { '3' }
    bitterness { '3' }
    sweetness { '3' }
    association :roaster
    # created_at { "" }
  end
end
