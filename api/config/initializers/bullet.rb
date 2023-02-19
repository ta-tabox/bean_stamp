if Rails.env.downcase == 'development'
  # 使っていないeager_loadingを許容する
  Bullet.add_whitelist type: :unused_eager_loading, class_name: 'Bean', association: :roast_level
  Bullet.add_whitelist type: :unused_eager_loading, class_name: 'Want', association: :offer
  Bullet.add_whitelist type: :unused_eager_loading, class_name: 'Bean', association: :bean_taste_tags
  Bullet.add_whitelist type: :unused_eager_loading, class_name: 'Bean', association: :taste_tags
  # N+1クエリが発生しても警告を出さない
  # Bullet.add_whitelist type: :n_plus_one_query, class_name: 'Post', association: :comments

  # 不必要なcountの検出を許容する
  # Bullet.add_whitelist type: :counter_cache, class_name: "Country", association: :cities
end
