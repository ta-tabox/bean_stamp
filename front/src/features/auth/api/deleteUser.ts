import type { AuthHeaders } from '@/features/auth/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
}

export const deleteUserReq = ({ headers }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.delete('auth', {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
