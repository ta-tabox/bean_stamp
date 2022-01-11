class Offer < ApplicationRecord
  belongs_to :bean, -> { includes(:roaster, :bean_images) }, inverse_of: :offers
  default_scope -> { order(created_at: :desc) }
  validates :bean_id, presence: true
  validates :ended_at, presence: true
  validates :roasted_at, presence: true
  validates :receipt_started_at, presence: true
  validates :receipt_ended_at, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :weight, presence: true, numericality: { only_integer: true }
  validates :amount, presence: true, numericality: { only_integer: true }
  # オファーの期日関連のバリデーションを追加する
  # オファー開始日は当日以降でないといけない且つ＜1ヶ月後
  # 焙煎日はオファー開始日＜焙煎日＜＝受け取り開始日且つ＜1ヶ月後
  # 受け取り開始日は焙煎日＜受け取り開始日＜受け取り終了日且つ＜1ヶ月後
  # 受け取り終了日は受け取り開始日＜受け取り終了日＜2ヶ月後

  # オファーが所属するロースターを返す
  def roaster
    self.bean.roaster
  end
end
