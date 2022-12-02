class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :timeoutable
  #  :confirmable, :lockable, :trackable and :omniauthable

  include DeviseTokenAuth::Concerns::User # SPA用にtokenを使用した認証を提供, deviseの設定の後に記述すること
  include JpPrefecture

  belongs_to :roaster, optional: true
  has_many :roaster_relationships, foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :following_roasters, through: :roaster_relationships, source: :roaster
  has_many :wants, dependent: :destroy
  has_many :want_offers, through: :wants, source: :offer
  has_many :likes, dependent: :destroy
  has_many :like_offers, through: :likes, source: :offer
  mount_uploader :image, ImageUploader
  jp_prefecture :prefecture_code

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :describe,
            length: {
              maximum: 140,
              too_long: ':140文字まで投稿できます。',
            }

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

  # ユーザーの好みのtaste_groupをids_count個のid一覧で返す
  # 今後より処理が複雑になる場合はバッチでスコア化して扱うように検討する
  def favorite_taste_group_ids(ids_count)
    # 評価済みのwantを取得
    wants = self.wants.where.not(rate: :unrated).includes(bean: :taste_tags)
    rating_list = []

    # want毎に評価をもとにコーヒー豆のtaste_tagsに点数をつける
    # taste_tagsは上位グループのtaste_group_idに変換する
    wants.each do |want|
      taste_group_ids = want.bean.taste_tags.map(&:taste_group_id)
      rating_list << taste_group_ids.map { |id| { id: id, rate: Want.rates[want.rate] } }
    end
    # 評価データリストをtaste_group_id毎に集計する
    sum_rating_list = merge_taste_rating_hash(rating_list)
    # 評価データの上位ids_count個文を取得する
    sum_rating_list.sort_by { |x| -x[:rate_sum] }.take(ids_count).map { |rate| rate[:taste_group_id] }
  end

  private

  # taste_group_idとrateのハッシュのリストを受け取り、taste_group_id別の合計値を配列で返す
  def merge_taste_rating_hash(*rating_list)
    rating_list
      .flatten
      .map(&:values)
      .each_with_object(Hash.new(0)) { |(id, num), hash| hash[id] += num }
      .map { |id, num| { taste_group_id: id, rate_sum: num } }
  end
end
