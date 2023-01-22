# Offerオブジェクトの属性から取得
json.extract! offer, :id, :bean_id, :price, :weight, :amount, :ended_at, :roasted_at, :receipt_started_at, :receipt_ended_at, :status, :created_at
json.created_at offer.created_at.to_date
json.want_count offer.wanted_users.length
json.roaster do
  json.id offer.roaster.id
  json.name offer.roaster.name
  json.thumbnail_url offer.roaster.image.thumb.url
end
json.bean do
  json.partial! 'api/v1/beans/bean', bean: offer.bean
end
