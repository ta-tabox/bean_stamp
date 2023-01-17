json.partial! 'api/v1/offers/offer', offer: @offer
json.want_count @offer.wanted_users.length
json.roaster do
  json.id @offer.roaster.id
  json.name @offer.roaster.name
  json.thumb_url @offer.roaster.image.url
end
json.bean do
  json.partial! 'api/v1/beans/bean', bean: @offer.bean
end
