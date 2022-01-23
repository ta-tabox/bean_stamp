20.times do |n|
  Offer.seed_once do |s|
    s.id = n + 1
    s.bean_id = n + 1
    s.created_at = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
    s.ended_at = Faker::Time.between(from: DateTime.now.next_day(7), to: DateTime.now.next_day(14))
    s.roasted_at = Faker::Time.between(from: DateTime.now.next_day(15), to: DateTime.now.next_day(21))
    s.receipt_started_at = Faker::Time.between(from: DateTime.now.next_day(22), to: DateTime.now.next_day(28))
    s.receipt_ended_at = Faker::Time.between(from: DateTime.now.next_day(29), to: DateTime.now.next_day(35))
    s.price = Faker::Number.within(range: 800..1800)
    s.weight = 100
    s.amount = Faker::Number.within(range: 10..50)
  end
end
