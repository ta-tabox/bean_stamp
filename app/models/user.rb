class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include JpPrefecture
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :timeoutable
  validates :describe,
            length: {
              maximum: 140,
              too_long: ':140文字まで投稿できます。',
            }
  validates :name, presence: true
  mount_uploader :image, ImageUploader
  belongs_to :roaster, optional: true
  jp_prefecture :prefecture_code

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
