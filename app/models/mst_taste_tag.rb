class MstTasteTag < ApplicationRecord
  has_many :bean_taste_tags, dependent: :destroy
  has_many :beans, through: :bean_taste_tags
end
