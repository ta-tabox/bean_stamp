class Want < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  has_one :roaster, through: :offer
  has_one :bean, through: :offer

  validates :user_id, presence: true
  validates :offer_id, presence: true
end
