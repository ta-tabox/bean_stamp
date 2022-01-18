class Roaster < ApplicationRecord
  include JpPrefecture
  has_many :users, dependent: :nullify
  has_many :beans, dependent: :destroy
  has_many :offers, -> { includes(:bean) }, through: :beans
  validates :name, presence: true
  validates :phone_number,
            presence: true,
            numericality: {
              only_integer: true,
            },
            length: {
              in: 10..11,
            }
  validates :prefecture_code, presence: true
  validates :address, presence: true
  validates :describe, length: { maximum: 300 }
  mount_uploader :image, ImageUploader
  jp_prefecture :prefecture_code
end
