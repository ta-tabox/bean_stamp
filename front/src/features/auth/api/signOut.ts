import type { AuthHeaders } from '@/features/auth/types'
import axios from '@/lib/axios'

export const signOutReq = (headers: AuthHeaders) => {
  const { uid, client, accessToken } = headers
  return axios.get('auth/sign_out', {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
