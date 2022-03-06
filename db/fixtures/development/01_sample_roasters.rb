20.times do |n|
  Roaster.seed_once do |s|
    s.id = n + 2
    s.name = "#{Faker::Restaurant.name_prefix}ロースター"
    s.phone_number = Faker::Number.leading_zero_number(digits: 10)
    s.prefecture_code = Faker::Number.within(range: 1..47)
    s.address = Faker::Address.city
    s.describe = Faker::Lorem.sentence(word_count: 5)
    s.image = File.open(Rails.root.join('db/fixtures/images/roasters/roaster_1.jpg'))
  end
end
