class Like < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  has_one :roaster, through: :offer
  has_one :bean, through: :offer

  validates :user_id, presence: true
  validates :offer_id, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :search_status, ->(status) { joins(:offer).where(offer: { status: status }) }
end
