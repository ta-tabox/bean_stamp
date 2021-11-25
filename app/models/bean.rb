class Bean < ApplicationRecord
  belongs_to :roaster
  has_many :bean_images, dependent: :destroy

  # accepts_nested_attributes_for :bean_images, allow_destroy: true
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
  validates :images,
            length: {
              maximum: 4,
              too_long: '画像は４枚まで投稿できます',
            }
end
