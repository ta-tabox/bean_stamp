# default sample roaster
Roaster.create!(
  name: '豆屋',
  phone_number: '0123456789',
  address: '東京都渋谷区*-*-*',
  describe: 'ここは豆太郎のロースターです',
)

# default sample user
User.create!(
  name: '豆太郎',
  email: 'user@example.com',
  area: '東京都',
  password: 'password',
  password_confirmation: 'password',
  describe: '私は豆太郎です。',
  roaster_id: 1,
)
