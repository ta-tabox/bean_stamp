class Offer < ApplicationRecord
  belongs_to :bean, inverse_of: :offers
  has_one :roaster, through: :bean
  has_many :wants, dependent: :restrict_with_error
  has_many :wanted_users, through: :wants, source: :user
  default_scope -> { order(created_at: :desc) }
  validates :bean_id, presence: true
  validates :ended_at, presence: true
  validates :roasted_at, presence: true
  validates :receipt_started_at, presence: true
  validates :receipt_ended_at, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :weight, presence: true, numericality: { only_integer: true }
  validates :amount, presence: true, numericality: { only_integer: true }
  validate :ended_at_cannot_be_in_the_past
  validate :roasted_at_cannot_be_earlier_than_ended_at
  validate :receipt_started_at_cannot_be_earlier_than_roasted_at
  validate :receipt_ended_at_cannot_be_earlier_than_receipt_started_at

  scope :following_by, lambda { |user|
    joins(:bean).where('roaster_id IN (?)', user.following_roaster_ids).includes(:roaster, bean: :bean_images)
  }

  def status
    today = Date.current
    return 'on-offering' if today.before? ended_at

    return 'on-roasting' if today.before? roasted_at

    return 'on-preparing' if today.before? receipt_started_at

    return 'on-selling' if today.before? receipt_ended_at

    'end-of-sales'
  end

  def status_value
    today = Date.current
    return 'オファー中' if today.before? ended_at

    return 'ロースト中' if today.before? roasted_at

    return '準備中' if today.before? receipt_started_at

    return '受け取り期間' if today.before? receipt_ended_at

    '受け取り終了'
  end

  private

  # オファーの期日関連のバリデーション
  def ended_at_cannot_be_in_the_past
    return unless ended_at&.past?

    errors.add(:ended_at, 'は本日以降の日付を入力してください')
  end

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
