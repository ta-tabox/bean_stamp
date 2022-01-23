20.times do |n|
  RoasterRelationship.seed_once do |s|
    s.follower_id = 1
    s.roaster_id = n + 2
  end
end

20.times do |n|
  RoasterRelationship.seed_once do |s|
    s.follower_id = n + 2
    s.roaster_id = 1
  end
end
