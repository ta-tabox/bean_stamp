import type { AuthHeaders } from '@/features/auth/types'
import axios from '@/lib/axios'

export const deleteUserReq = (headers: AuthHeaders) => {
  const { uid, client, accessToken } = headers
  return axios.delete('auth', {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
