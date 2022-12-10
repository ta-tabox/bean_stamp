import type { AuthHeaders } from '@/features/auth/types'
import type { Roaster } from '@/features/roasters'
import type { User } from '@/features/users'
import axios from '@/lib/axios'

type CurrentUserResponse = {
  isLogin: boolean
  user: User
  roaster: Roaster | null
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
