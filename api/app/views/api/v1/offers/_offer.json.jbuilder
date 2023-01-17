# Offerオブジェクトの属性から取得
json.extract! offer, :id, :bean_id, :price, :weight, :amount, :ended_at, :roasted_at, :receipt_started_at, :receipt_ended_at, :status, :created_at
json.roaster_id offer.roaster.id
json.created_at offer.created_at.to_date
