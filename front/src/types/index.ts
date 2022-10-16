// サインアップ
export type SignUpParams = {
  name: string
  email: string
  prefectureCode: string
  password: string
  passwordConfirmation: string
}

// サインイン
export type SignInParams = {
  email: string
  password: string
}

export type User = {
  email: string
  provider: string
  uid: string
  image: {
    url: string | null
    thumb: {
      url: string | null
    }
  }
  id: number
  name: string
  prefectureCode: string
  describe: string | null
  roasterId: number | null
  guest: boolean
  admin: boolean
  allowPasswordChange: boolean
}
