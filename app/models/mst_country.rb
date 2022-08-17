class MstCountry < ApplicationRecord
  # has_many :beans,
  #          dependent: :nullify,
  #          foreign_key: 'country_id', # 検索する外部キーが異なるため指定
  #          inverse_of: :country
end
