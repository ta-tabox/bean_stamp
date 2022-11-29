import type { AuthHeaders, UserResponse } from '@/features/auth/types'
import axios from '@/lib/axios'

type CurrentUserResponse = UserResponse & {
  isLogin: boolean
}

type Options = {
  headers: AuthHeaders
}

export const getSignInUser = ({ headers }: Options) => {
  const { uid, client, accessToken } = headers

  return axios.get<CurrentUserResponse>('/auth/sessions', {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
