guest_user = User.find_by(guest: true)
users = User.where.not(guest: true).take(10)
offers = Offer.order(:created_at).take(10)

offers.count.times do |n|
  Want.seed_once do |s|
    s.id = n + 1
    s.user_id = guest_user.id
    s.offer_id = offers[n].id
  end
end

users.count.times do |n|
  offers.count.times do |i|
    Want.seed_once do |s|
      s.id = offers.count + (n * offers.count) + i + 1
      s.user_id = users[n].id
      s.offer_id = offers[i].id
    end
  end
end
