guest_user = User.find_by(guest: true)
users = User.where.not(guest: true).take(10)
beans = Bean.order(:created_at).where.not(roaster_id: guest_user.roaster.id).take(10)
id = 1

beans.count.times do |bean_num|
  Want.seed_once do |s|
    s.id = id
    s.user_id = guest_user.id
    s.offer_id = beans[bean_num].offers[0].id
  end
  id += 1
end

users.count.times do |m|
  beans.count.times do |i|
    Want.seed_once do |s|
      s.id = id
      s.user_id = users[m].id
      s.offer_id = beans[i].offers[0].id
    end
  end
  id += 1
end

# Offerの日程に応じた状態確認用テストウォンツ
bean = Bean.order(:created_at).where.not(roaster_id: guest_user.roaster.id).last
bean.offers.count.times do |offer_num|
  Want.seed_once do |s|
    s.id = id
    s.user_id = guest_user.id
    s.offer_id = bean.offers[offer_num].id
  end
  id += 1
end
