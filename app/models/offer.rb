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

  # オファーが所属するロースターを返す
  def roaster
    self.bean.roaster
  end
end
