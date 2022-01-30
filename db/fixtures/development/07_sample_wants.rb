guest_user = User.find_by(guest: true)
users = User.where.not(guest: true).take(10)
beans = Bean.order(:created_at).where.not(roaster_id: guest_user.roaster.id).take(10)
# offers = Offer.order(:created_at).take(10)

beans.count.times do |n|
  Want.seed_once do |s|
    s.id = n + 1
    s.user_id = guest_user.id
    s.offer_id = beans[n].offers[0].id
  end
end

users.count.times do |n|
  beans.count.times do |i|
    Want.seed_once do |s|
      s.id = beans.count + (n * beans.count) + i + 1
      s.user_id = users[n].id
      s.offer_id = beans[i].offers[0].id
    end
  end
end
