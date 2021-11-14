# guest roaster
Roaster.create!(
  name: 'ゲストロースター',
  phone_number: '0123456789',
  prefecture_code: '13',
  address: '**区**丁目**-**',
  describe: '閲覧用のロースターです',
)

# guest user
User.create!(
  name: 'ゲストユーザー',
  email: 'guest@example.com',
  prefecture_code: '13',
  password: 'password',
  password_confirmation: 'password',
  describe: '閲覧用のロースターです',
  roaster_id: 1,
)
