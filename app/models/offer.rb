class Offer < ApplicationRecord
  attr_accessor :status, :status_value

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
  scope :on_preparing, -> { where('roasted_at < :today AND receipt_started_at > :today', { today: Date.current }).order(:receipt_started_at) }
  scope :on_selling, -> { where('receipt_started_at <= :today AND receipt_ended_at >= :today', { today: Date.current }).order(:receipt_ended_at) }
  scope :end_of_sales, -> { where('receipt_ended_at < ?', Date.current).order(receipt_ended_at: :desc) }

  def set_status
    status_list = Offer.status_list
    today = Date.current
    if ended_at >= Date.current
      self.status = 'on_offering'
      self.status_value = status_list[:on_offering]
    elsif roasted_at >= today
      self.status = 'on_roasting'
      self.status_value = status_list[:on_roasting]
    elsif receipt_started_at > today
      self.status = 'on_preparing'
      self.status_value = status_list[:on_preparing]
    elsif receipt_ended_at >= today
      self.status = 'on_selling'
      self.status_value = status_list[:on_selling]
    else
      self.status = 'end_of_sales'
      self.status_value = status_list[:end_of_sales]
    end
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
