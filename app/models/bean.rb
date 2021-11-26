class Bean < ApplicationRecord
  belongs_to :roaster
  has_many :bean_images, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :roaster_id, presence: true
  validates :name, presence: true
  validates :country, presence: true
  validates :describe, length: { maximum: 300 }
  with_options inclusion: { in: (1..5) } do
    validates :acidity
    validates :flavor
    validates :body
    validates :bitterness
    validates :sweetness
  end
end
