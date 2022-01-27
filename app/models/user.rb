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
  belongs_to :roaster, optional: true
  has_many :roaster_relationships, foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :following_roasters, through: :roaster_relationships, source: :roaster
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

  # ロースターをフォローする
  def follow_roaster(roaster)
    following_roasters << roaster
  end

  # ロースターのフォローを解除する
  def unfollow_roaster(roaster)
    # roaster_relationships.find_by(roaster_id: roaster.id).destroy
    following_roasters.delete(roaster)
  end

  # 現在のユーザーがロースターをフォローしているか？
  def following_roaster?(roaster)
    following_roasters.include?(roaster)
  end

  # user#homeのフォローしたロースターのオファー一覧を返す
  def feed
    # following_roaster_idsに相当するサブセレクト
    following_roaster_ids = 'SELECT `roasters`.`id` FROM `roasters`
                             INNER JOIN `roaster_relationships` ON `roasters`.`id` = `roaster_relationships`.`roaster_id`
                             WHERE `roaster_relationships`.`follower_id` = :user_id'
    Offer.joins(:bean).where("roaster_id IN (#{following_roaster_ids})", user_id: id).includes(:roaster, bean: :bean_images)
  end
end
