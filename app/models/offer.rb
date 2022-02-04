class Offer < ApplicationRecord
  belongs_to :bean, inverse_of: :offers
  has_one :roaster, through: :bean
  has_many :wants, dependent: :restrict_with_error
  has_many :wanted_users, through: :wants, source: :user
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

  scope :recent, -> { order(created_at: :desc) }
  scope :active, -> { where('receipt_ended_at > ?', Date.current) }
  scope :on_offering, -> { where('ended_at >= ?', Date.current).order(:ended_at) }
  scope :on_roasting, -> { where('ended_at < :today AND roasted_at >= :today', { today: Date.current }).order(:roasted_at) }
  scope :on_preparing, -> { where('roasted_at < :today AND receipt_started_at >= :today', { today: Date.current }).order(:receipt_started_at) }
  scope :on_selling, -> { where('receipt_started_at < :today AND receipt_ended_at >= :today', { today: Date.current }).order(:receipt_ended_at) }
  scope :end_of_sales, -> { where('receipt_ended_at < ?', Date.current).order(receipt_ended_at: :desc) }

  def status
    status = Offer.status_list.keys
    today = Date.current
    return status[0] if today.before? ended_at

    return status[1] if today.before? roasted_at

    return status[2] if today.before? receipt_started_at

    return status[3] if today.before? receipt_ended_at

    status[4]
  end

  def status_value
    values = Offer.status_list.values
    today = Date.current
    return values[0] if today.before? ended_at

    return values[1] if today.before? roasted_at

    return values[2] if today.before? receipt_started_at

    return values[3] if today.before? receipt_ended_at

    values[4]
  end

  # Offerのstatusの種類と名称を定義
  def self.status_list
    { on_offering: 'オファー中', on_roasting: 'ロースト中', on_preparing: '準備中', on_selling: '受け取り期間', end_of_sales: '受け取り終了' }
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
