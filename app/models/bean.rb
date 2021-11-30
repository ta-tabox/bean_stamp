class Bean < ApplicationRecord
  MAX_UPLOAD_IMAGES_COUNT = 4
  attr_accessor :upload_images
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
  validate :upload_images_cannot_be_greater_than_max_upload_images_count

  def update_with_bean_images(bean_params)
    self.transaction do
      self.update!(bean_params)
      update_bean_images if self.upload_images
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  # アップロードする画像数がMAX_UPLOAD_IMAGES_COUNT以下であるか検証する
  def upload_images_cannot_be_greater_than_max_upload_images_count
    return unless upload_images && upload_images.length > MAX_UPLOAD_IMAGES_COUNT
    errors.add(
      :bean_images,
      "は#{MAX_UPLOAD_IMAGES_COUNT}枚までしか登録できません",
    )
  end

  # upload_imagesがある場合は登録ずみの画像を削除し新たにcreateする
  def update_bean_images
    # 登録ずみの画像を全て削除する
    self.bean_images.each(&:destroy)
    self.upload_images.each do |img|
      self.bean_images.create!(image: img, bean_id: self.id)
    end
  end
end
