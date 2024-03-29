class Offer < ApplicationRecord
  belongs_to :bean, inverse_of: :offers
  has_one :roaster, through: :bean
  has_many :wants, dependent: :restrict_with_error
  has_many :wanted_users, through: :wants, source: :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  enum status: { on_offering: 0, on_roasting: 1, on_preparing: 2, on_selling: 3, end_of_sales: 4 }

  validates :bean_id, presence: true
  validates :ended_at, presence: true
  validates :roasted_at, presence: true
  validates :receipt_started_at, presence: true
  validates :receipt_ended_at, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :weight, presence: true, numericality: { only_integer: true }
  validates :amount, presence: true, numericality: { only_integer: true }
  validate :roasted_at_cannot_be_earlier_than_ended_at
  validate :receipt_started_at_cannot_be_earlier_than_roasted_at
  validate :receipt_ended_at_cannot_be_earlier_than_receipt_started_at

  scope :following_by, lambda { |user|
    joins(:bean).where('roaster_id IN (?)', user.following_roaster_ids)
  }
  scope :recent, -> { order(created_at: :desc) }
  scope :active, -> { where('receipt_ended_at > ?', Date.current) }
  scope :search_status, ->(status) { where(status: status) }

  # userと同都道府県のロースター 且つ favorite_taste_group_idsのタグを持つコーヒー豆
  # 且つ ユーザーが所属するロースター以外のオファーを返す
  # user.roaster.id = nilの場合null以外で検索→レコードが取得できない → '0' 以外で検索するようにする
  scope :recommended_for, lambda { |user|
    joins(bean: %i[roaster taste_tags])
      .where('mst_taste_tags.taste_group_id IN (?) AND roasters.prefecture_code = (?)', user.favorite_taste_group_ids(2), user.prefecture_code)
      .where.not('roasters.id = (?)', user.roaster&.id || 0)
      .distinct
  }

  scope :near_for, lambda { |user|
    joins(bean: %i[roaster taste_tags])
      .where('roasters.prefecture_code = (?)', user.prefecture_code)
      .where.not('roasters.id = (?)', user.roaster&.id || 0)
      .distinct
  }

  def update_status
    today = Date.current
    if ended_at >= today
      on_offering!
    elsif roasted_at >= today
      on_roasting!
    elsif receipt_started_at > today
      on_preparing!
    elsif receipt_ended_at >= today
      on_selling!
    else
      end_of_sales!
    end
  end

  private

  # オファーの期日関連のバリデーション
  def roasted_at_cannot_be_earlier_than_ended_at
    return unless ended_at && roasted_at
    return unless roasted_at.before? ended_at

    errors.add(:roasted_at, 'はオファー終了日以降の日付を入力してください')
  end

  def receipt_started_at_cannot_be_earlier_than_roasted_at
    return unless roasted_at && receipt_started_at
    return unless receipt_started_at.before? roasted_at

    errors.add(:receipt_started_at, 'は焙煎日以降の日付を入力してください')
  end

  def receipt_ended_at_cannot_be_earlier_than_receipt_started_at
    return unless receipt_started_at && receipt_ended_at
    return unless receipt_ended_at.before? receipt_started_at

    errors.add(:receipt_ended_at, 'は受け取り開始日以降の日付を入力してください')
  end
end
