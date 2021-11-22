# コーヒー豆のサンプルデータ
30.times do |n|
  Bean.create!(
    name: "テストビーンズ#{n + 1}",
    roaster_id: 1,
    created_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
    country: Faker::Coffee.country,
    subregion: Faker::Movies::Hobbit.location,
    farm: Faker::BossaNova.song,
    variety: Faker::Coffee.variety,
    elevation: Faker::Number.within(range: 800..1800),
    process: Faker::Coffee.process,
    describe: Faker::Lorem.sentence(word_count: 5),
    cropped_at: Faker::Date.in_date_period(year: 2020),
    acidity: Faker::Number.within(range: 1..5),
    flavor: Faker::Number.within(range: 1..5),
    body: Faker::Number.within(range: 1..5),
    bitterness: Faker::Number.within(range: 1..5),
    sweetness: Faker::Number.within(range: 1..5),
  )
end
