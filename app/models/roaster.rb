class Roaster < ApplicationRecord
  include JpPrefecture
  has_many :users, dependent: :nullify
  has_many :beans, dependent: :destroy
  has_many :offers, through: :beans
  has_many :roaster_relationships, dependent: :destroy
  has_many :followers, through: :roaster_relationships
  mount_uploader :image, ImageUploader
  jp_prefecture :prefecture_code

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
end
