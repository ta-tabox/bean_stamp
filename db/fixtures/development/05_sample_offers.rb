guest_roaster = Roaster.find_by(guest: true)
guest_roaster_beans = guest_roaster.beans
beans = Bean.where.not(roaster_id: guest_roaster.id)
id = 1

guest_roaster_beans.count.times do |n|
  Offer.seed do |s|
    s.id = id
    s.bean_id = guest_roaster_beans[n].id
    s.created_at = Faker::Time.between(from: DateTime.now.prev_day(15), to: DateTime.now.prev_day(10))
    s.ended_at = Faker::Date.between(from: Date.current.next_day(7), to: Date.current.next_day(14))
    s.roasted_at = Faker::Date.between(from: Date.current.next_day(15), to: Date.current.next_day(21))
    s.receipt_started_at = Faker::Date.between(from: Date.current.next_day(22), to: Date.current.next_day(28))
    s.receipt_ended_at = Faker::Date.between(from: Date.current.next_day(29), to: Date.current.next_day(35))
    s.price = Faker::Number.within(range: 800..1800)
    s.weight = 100
    s.amount = Faker::Number.within(range: 10..50)
  end
  id += 1
end

beans.count.times do |bean_num|
  Offer.seed do |s|
    s.id = id
    s.bean_id = beans[bean_num].id
    s.created_at = Faker::Time.between(from: DateTime.now.prev_day(15), to: DateTime.now.prev_day(10))
    s.ended_at = Faker::Date.between(from: Date.current.next_day(7), to: Date.current.next_day(14))
    s.roasted_at = Faker::Date.between(from: Date.current.next_day(15), to: Date.current.next_day(21))
    s.receipt_started_at = Faker::Date.between(from: Date.current.next_day(22), to: Date.current.next_day(28))
    s.receipt_ended_at = Faker::Date.between(from: Date.current.next_day(29), to: Date.current.next_day(35))
    s.price = Faker::Number.within(range: 800..1800)
    s.weight = 100
    s.amount = 50
  end
  id += 1
end

# Offerの日程に応じた状態確認用テストオファー
my_and_other_beans = []
my_and_other_beans << guest_roaster_beans.first
my_and_other_beans << Bean.order(:created_at).where.not(roaster_id: guest_roaster.id).last

# on-roasting
my_and_other_beans.count.times do |bean_num|
  Offer.seed do |s|
    s.id = id
    s.bean_id = my_and_other_beans[bean_num].id
    s.created_at = DateTime.now.prev_day(6)
    s.ended_at = Date.current.prev_day(1)
    s.roasted_at = Date.current.next_day(1)
    s.receipt_started_at = Date.current.next_day(5)
    s.receipt_ended_at = Date.current.next_day(10)
    s.price = 1000
    s.weight = 100
    s.amount = 100
  end
  id += 1
end

my_and_other_beans.count.times do |bean_num|
  # on-preparing
  Offer.seed do |s|
    s.id = id
    s.bean_id = my_and_other_beans[bean_num].id
    s.created_at = DateTime.now.prev_day(6)
    s.ended_at = Date.current.prev_day(5)
    s.roasted_at = Date.current.prev_day(1)
    s.receipt_started_at = Date.current.next_day(1)
    s.receipt_ended_at = Date.current.next_day(5)
    s.price = 1000
    s.weight = 100
    s.amount = 100
  end
  id += 1
end

# on-selling
my_and_other_beans.count.times do |bean_num|
  Offer.seed do |s|
    s.id = id
    s.bean_id = my_and_other_beans[bean_num].id
    s.created_at = DateTime.now.prev_day(6)
    s.ended_at = Date.current.prev_day(5)
    s.roasted_at = Date.current.prev_day(3)
    s.receipt_started_at = Date.current.prev_day(1)
    s.receipt_ended_at = Date.current.next_day(1)
    s.price = 1000
    s.weight = 100
    s.amount = 100
  end
  id += 1
end

# end-of-sales
my_and_other_beans.count.times do |bean_num|
  Offer.seed do |s|
    s.id = id
    s.bean_id = my_and_other_beans[bean_num].id
    s.created_at = DateTime.now.prev_day(6)
    s.ended_at = Date.current.prev_day(5)
    s.roasted_at = Date.current.prev_day(3)
    s.receipt_started_at = Date.current.prev_day(2)
    s.receipt_ended_at = Date.current.prev_day(1)
    s.price = 1000
    s.weight = 100
    s.amount = 100
  end
  id += 1
end

# 上限ギリギリのオファー
amount_max_beans = beans[1..5]
amount_max_beans.count.times do |bean_num|
  Offer.seed do |s|
    s.id = id
    s.bean_id = amount_max_beans[bean_num].id
    s.created_at = DateTime.now.prev_day(6)
    s.ended_at = Date.current.prev_day(5)
    s.roasted_at = Date.current.prev_day(3)
    s.receipt_started_at = Date.current.prev_day(2)
    s.receipt_ended_at = Date.current.prev_day(1)
    s.price = 1000
    s.weight = 100
    s.amount = 10
  end
  id += 1
end
