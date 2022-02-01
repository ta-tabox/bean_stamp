guest_roaster = Roaster.find_by(guest: true)
roasters = Roaster.where.not(guest: true).order(:created_at).take(3)
id = 1

5.times do |n|
  Bean.seed_once do |s|
    s.id = id
    s.name = "#{guest_roaster.name}のテストビーン#{n + 1}"
    s.roaster_id = guest_roaster.id
    s.created_at = Faker::Time.between(from: DateTime.now - 15, to: DateTime.now - 10)
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
  id += 1
end

roasters.count.times do |roaster_num|
  10.times do |i|
    Bean.seed_once do |s|
      s.id = id
      s.name = "#{roasters[roaster_num].name}のテストビーン#{i + 1}"
      s.roaster_id = roasters[roaster_num].id
      s.created_at = Faker::Time.between(from: DateTime.now - 15, to: DateTime.now - 10)
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
    id += 1
  end
end
