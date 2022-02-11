class Want < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  has_one :roaster, through: :offer
  has_one :bean, through: :offer

  enum rate: { unrated: 0, bad: 1, so_so: 2, good: 3, excellent: 4 }

  validates :user_id, presence: true
  validates :offer_id, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :active, -> { joins(:offer).merge(Offer.active).with_associations }
  scope :search_status, ->(status) { joins(:offer).where(offer: { status: status }).with_associations }
  scope :with_associations, -> { includes(:roaster, bean: :bean_images) }
end
