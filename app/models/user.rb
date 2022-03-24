class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  include JpPrefecture
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :timeoutable
  belongs_to :roaster, optional: true
  has_many :roaster_relationships, foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :following_roasters, through: :roaster_relationships, source: :roaster
  has_many :wants, dependent: :destroy
  has_many :want_offers, through: :wants, source: :offer
  has_many :likes, dependent: :destroy
  has_many :like_offers, through: :likes, source: :offer
  mount_uploader :image, ImageUploader
  jp_prefecture :prefecture_code

  validates :describe,
            length: {
              maximum: 140,
              too_long: ':140文字まで投稿できます。',
            }
  validates :name, presence: true

  # ユーザーが所属するロースターと一致しているか？
  def belonged_roaster?(roaster)
    self.roaster == roaster
  end

  # ユーザーが所属するロースターのコーヒー豆と一致しているか？
  def had_bean?(bean)
    roaster == bean.roaster
  end

  # ユーザーが所属するロースターのオファーと一致しているか？
  def had_offer?(offer)
    roaster == offer.roaster
  end
end
