guest_user = User.find_by(guest: true)
users = User.where.not(guest: true)
guest_roaster = Roaster.find_by(guest: true)
roasters = Roaster.where.not(guest: true)

roasters.count.times do |n|
  RoasterRelationship.seed_once do |s|
    s.id = n + 1
    s.follower_id = guest_user.id
    s.roaster_id = roasters[n].id
  end
end

users.count.times do |n|
  RoasterRelationship.seed_once do |s|
    s.id = roasters.count + n + 1
    s.follower_id = users[n].id
    s.roaster_id = guest_roaster.id
  end
end
