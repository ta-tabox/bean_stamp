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
