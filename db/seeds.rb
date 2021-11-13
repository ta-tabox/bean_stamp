# default sample roaster
Roaster.create!(
  name: '豆屋',
  phone_number: '0123456789',
  prefecture_code: '12',
  describe: 'ここは豆太郎のロースターです',
)

# default sample user
User.create!(
  name: '豆太郎',
  email: 'user@example.com',
  prefecture_code: '12',
  password: 'password',
  password_confirmation: 'password',
  describe: '私は豆太郎です。',
  roaster_id: 1,
)
