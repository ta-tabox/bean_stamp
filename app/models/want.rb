class Want < ApplicationRecord
  belongs_to :user
  belongs_to :offer

  validates :user_id, presence: true
  validates :offer_id, presence: true
end
