import type { User } from '@/features/users'

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

// UserAuthHeaders
export type AuthHeaders = {
  uid: string
  client: string
  accessToken: string
}

// apiからのレスポンスは{ data { data : User } }という階層になっている
export type UserResponse = {
  data: User
}
