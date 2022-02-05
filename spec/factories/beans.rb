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
    roaster
    roast_level { MstRoastLevel.find(3) }

    trait :with_image do
      after(:build) do |bean|
        bean.bean_images << build(:bean_image, bean: bean)
      end
    end

    trait :with_3_taste_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(1)
        bean.taste_tags << MstTasteTag.find(2)
        bean.taste_tags << MstTasteTag.find(3)
      end
    end

    trait :with_2_taste_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(1)
        bean.taste_tags << MstTasteTag.find(2)
      end
    end

    trait :invalid do
      name { nil }
    end

    trait :update do
      name { 'アップデートビーン' }
    end

    trait :with_image_and_tags do
      after(:build) do |bean|
        bean.bean_images << build(:bean_image, bean: bean)
        bean.taste_tags << MstTasteTag.find(1)
        bean.taste_tags << MstTasteTag.find(2)
        bean.taste_tags << MstTasteTag.find(3)
      end
    end
  end

  factory :bean_image do
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg') }
  end

  # createアクションのparams[:bean_image]用のパラメータ
  factory :bean_image_params, class: BeanImage do
    image { [Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg')] }
  end

  factory :too_big_bean_image, class: BeanImage do
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/over_5mb_sample.jpg'), 'image/jpg') }
  end

  factory :taste_tag, class: BeanTasteTag do
    mst_taste_tag_id { MstTasteTag.find(1).id }
  end
end
