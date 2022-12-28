# Beanオブジェクトの属性から取得
json.extract! bean, :id,
              :roaster_id,
              :name,
              :subregion,
              :farm,
              :variety,
              :elevation,
              :process,
              :cropped_at,
              :describe,
              :acidity,
              :flavor,
              :body,
              :bitterness,
              :sweetness
json.cropped_at "#{bean.cropped_at.year}年 #{bean.cropped_at.month}月"
json.country bean.country.name # ネストした属性 country_id から変換
json.roast_level bean.roast_level.name # ネストした属性 roast_lavel_id から変換
json.taste = bean.taste_tags.map(&:name) # 1対多の属性 tasteの配列を返す
# WARNING 画像update時には以前の画像も残って返される. 変数beanがupdate時に再代入されないため、update前のデータをそのまま持っている？
json.images = bean.bean_images.map { |bean_image| bean_image.image.thumb.url } # 1対多の属性 urlの配列を返す
