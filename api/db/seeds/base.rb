# ゲストユーザーの作成
guest = User.find_by(guest: true)
return if guest

User.create!(
  name: 'ゲストユーザー',
  email: 'guest@example.com',
  uid: 'guest@example.com',
  prefecture_code: '13',
  password: 'password',
  password_confirmation: 'password',
  describe: '閲覧用のユーザーです',
  image: File.open(Rails.root.join('db/fixtures/images/users/user_1.jpg')),
  guest: true,
)

# ゲストロースターの作成
user = User.find_by(guest: true)
user.create_roaster!(
  name: 'ゲストロースター',
  phone_number: '0123456789',
  prefecture_code: '13',
  address: '**区**丁目**-**',
  describe: '閲覧用のロースターです',
  image: File.open(Rails.root.join('db/fixtures/images/roasters/roaster_1.jpg')),
  guest: true,
)
user.save!
