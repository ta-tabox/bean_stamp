// サインアップ
export type SignUpParams = {
  name: string
  email: string
  prefecture_code: string
  password: string
  passwordConfirmation: string
}

// サインイン
export type SignInParams = {
  email: string
  password: string
}

export type User = {
  id: number
  name: string
  username: string
  email: string
  address: {
    street: string
    suite: string
    city: string
    zipcode: string
    geo: {
      lat: string
      lng: string
    }
  }
  phone: string
  website: string
  company: {
    name: string
    catchPhrase: string
    bs: string
  }
}

// ユーザー
// export type User = {
//   id: number
//   uid: string
//   provider: string
//   email: string
//   name: string
//   prefecture_code: string
//   describe?: string
//   image?: string
//   roasterId?: number
//   allowPasswordChange: boolean
//   createdAt: Date
//   updatedAt: Date
//   rememberCreatedAt?: Date
// }
