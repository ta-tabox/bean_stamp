# guest roaster
# Roaster.create!(
#   name: 'ゲストロースター',
#   phone_number: '0123456789',
#   prefecture_code: '13',
#   address: '**区**丁目**-**',
#   describe: '閲覧用のロースターです',
#   guest: true,
# )

# ゲストユーザーの作成
User.create!(
  name: 'ゲストユーザー',
  email: 'guest@example.com',
  prefecture_code: '13',
  password: 'password',
  password_confirmation: 'password',
  describe: '閲覧用のロースターです',
  # roaster_id: 1,
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
  guest: true,
)
user.save!
