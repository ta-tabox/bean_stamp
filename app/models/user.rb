class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :timeoutable
  validates :describe,
            length: {
              maximum: 140,
              too_long: ':140文字まで投稿できます。',
            }
  validates :name, presence: true
  mount_uploader :image, ImageUploader
end
