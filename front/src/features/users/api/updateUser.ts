import type { AuthHeaders, UserResponse } from '@/features/auth/types'
import type { UserUpdateParams } from '@/features/users/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  params: UserUpdateParams
}

export const updateUser = ({ headers, params }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.patch<UserResponse>('auth', params, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
