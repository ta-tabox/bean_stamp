class BeanImage < ApplicationRecord
  belongs_to :bean
  mount_uploader :image, ImageUploader
end
