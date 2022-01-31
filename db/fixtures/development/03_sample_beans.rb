roasters = Roaster.order(:created_at).take(6)
roasters.count.times do |n|
  10.times do |i|
    Bean.seed_once do |s|
      s.id = (n * 10) + i + 1
      s.name = "#{roasters[n].name}のテストビーン#{i}"
      s.roaster_id = roasters[n].id
      s.created_at = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
      s.country = Faker::Coffee.country
      s.subregion = Faker::Movies::Hobbit.location
      s.farm = Faker::BossaNova.song
      s.variety = Faker::Coffee.variety
      s.elevation = Faker::Number.within(range: 800..1800)
      s.process = Faker::Coffee.process
      s.describe = Faker::Lorem.sentence(word_count: 5)
      s.cropped_at = Faker::Date.in_date_period(year: 2020)
      s.acidity = Faker::Number.within(range: 1..5)
      s.flavor = Faker::Number.within(range: 1..5)
      s.body = Faker::Number.within(range: 1..5)
      s.bitterness = Faker::Number.within(range: 1..5)
      s.sweetness = Faker::Number.within(range: 1..5)
      s.roast_level_id = Faker::Number.within(range: 1..5)
    end
  end
end
