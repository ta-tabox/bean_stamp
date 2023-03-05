FactoryBot.define do
  factory :bean do
    name { 'テストビーン' }
    # country { MstCountry.find(5) }
    country_id { '5' }
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
    # roast_level { MstRoastLevel.find(3) }
    roast_level_id { '3' }

    trait :with_image do
      after(:build) do |bean|
        bean.bean_images << build(:bean_image, bean: bean)
      end
    end

    trait :with_3_taste_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(1)
        bean.taste_tags << MstTasteTag.find(3)
        bean.taste_tags << MstTasteTag.find(10)
      end
    end

    trait :with_2_taste_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(1)
        bean.taste_tags << MstTasteTag.find(10)
      end
    end

    # User#favorite_taste_group_idsテストで使用
    trait :with_floral_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(1) # floral
        bean.taste_tags << MstTasteTag.find(2) # blach tea
        bean.taste_tags << MstTasteTag.find(3) # chamomile
      end
    end

    trait :with_berry_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(6) # berry
        bean.taste_tags << MstTasteTag.find(7) # blackberry
        bean.taste_tags << MstTasteTag.find(8) # raspberry
      end
    end

    trait :with_fruit_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(14) # fruit
        bean.taste_tags << MstTasteTag.find(15) # coconut
        bean.taste_tags << MstTasteTag.find(16) # cherry
      end
    end

    # Offer#recommended_forテストで使用
    trait :with_floral_berry_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(1) # floral
        bean.taste_tags << MstTasteTag.find(6) # berry
      end
    end
    trait :with_floral_other_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(1) # floral
        bean.taste_tags << MstTasteTag.find(22) # citrus
      end
    end
    trait :with_berry_other_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(6) # berry
        bean.taste_tags << MstTasteTag.find(22) # citrus
      end
    end
    trait :with_other_other_tags do
      after(:build) do |bean|
        bean.taste_tags << MstTasteTag.find(22) # citrus
        bean.taste_tags << MstTasteTag.find(27) # fermented
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
        bean.taste_tags << MstTasteTag.find(3)
        bean.taste_tags << MstTasteTag.find(10)
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

  # API:createアクションのparams[:bean_image]用のパラメータ
  factory :bean_image_params_for_api, class: BeanImage do
    images { [Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg')] }
  end

  factory :too_big_bean_image, class: BeanImage do
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/over_5mb_sample.jpg'), 'image/jpg') }
  end

  factory :taste_tag, class: BeanTasteTag do
    mst_taste_tag_id { MstTasteTag.find(1).id }
  end
end
