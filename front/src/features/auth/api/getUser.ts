import type { AuthHeaders, UserResponse } from '@/features/auth/types'
import axios from '@/lib/axios'

type CurrentUserResponse = UserResponse & {
  isLogin: boolean
}

export const getUser = (headers: AuthHeaders) => {
  const { uid, client, accessToken } = headers

  return axios.get<CurrentUserResponse>('/auth/sessions', {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
