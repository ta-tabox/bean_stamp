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
  belongs_to :roaster, optional: true

  # ユーザーが所属するロースターと一致しているか？
  def roaster?(roaster)
    self.roaster == roaster
  end

  # ゲストユーザーを作成する
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲストユーザー'
      user.area = '東京都'
      user.describe = '閲覧用のユーザーです。'
    end
  end

  # ゲストユーザー用のロースターを作成する
  def guest_roaster(user)
    unless user.roaster ||= Roaster.find_by(name: 'ゲストロースター')
      user.create_roaster do |roaster|
        roaster.name = 'ゲストロースター'
        roaster.phone_number = '0123456789'
        roaster.address = '東京都渋谷区*-*-*'
        roaster.describe = '閲覧用のロースターです'
      end
    end
    user.save
  end
end
