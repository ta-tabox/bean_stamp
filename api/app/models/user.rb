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

  # NOTE: 今後より処理が複雑になる場合はバッチ処理でスコア化して扱うように検討する
  # ユーザーの好みのtaste_groupをids_count個のid一覧で返す
  def favorite_taste_group_ids(ids_count)
    # 評価済みのwantを取得
    wants = self.wants.where.not(rate: :unrated).includes(bean: :taste_tags)
    rating_list = []

    # 評価済みのコーヒー豆から[{id: 1, rate: 2}, ...]の形式で風味グループのidと点数の組み合わせの配列を作成
    wants.each do |want|
      # コーヒー豆の風味タグから風味グループのid一覧を取得
      taste_group_ids = want.bean.taste_tags.map(&:taste_group_id)
      # 風味グループのidとwant.rateの組み合わせをリストに追加
      rating_list << taste_group_ids.map { |id| { id: id, rate: Want.rates[want.rate] } }
    end

    # 評価データリストをtaste_group_id毎に集計する
    sum_rating_list = merge_taste_rating_hash(rating_list)

    # 評価データの上位ids_count個分の風味グループのidを返却
    sum_rating_list.sort_by { |x| -x[:rate_sum] }.take(ids_count).map { |rate| rate[:taste_group_id] }
  end

  private

  # taste_group_idとrateのハッシュのリストを受け取り、taste_group_id別の合計値を配列で返す
  # [[{:taste_group_id=>1, :rate=>1}, {:taste_group_id=>6, :rate=>2}], [{:taste_group_id=>1, :rate=>2}, {:taste_group_id=>6, :rate=>2}]]
  # -> [{ taste_group_id: 1, rate_sum: 3 }, { taste_group_id: 6, rate_sum: 4 }]
  def merge_taste_rating_hash(*rating_list)
    rating_list
      .flatten # ハッシュの配列の配列を同階層に変換 [[{},{}], [{}, {}]] -> [{},{},{},{}]
      .map(&:values) # {:taste_group_id=>1, :rate=>1} -> [1, 1] ハッシュをvalueの配列に変換
      .each_with_object(Hash.new(0)) { |(id, num), hash| hash[id] += num } # 空のハッシュに対して hash[id] += numを繰り返す、結果としてid毎にnumの合計値が得られる
      .map { |id, num| { taste_group_id: id, rate_sum: num } } # {[1, 3], [6, 4]} -> [{ taste_group_id: 1, rate_sum: 3 }, { taste_group_id: 6, rate_sum: 4 }]
  end
end
