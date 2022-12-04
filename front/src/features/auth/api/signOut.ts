import type { AuthHeaders } from '@/features/auth/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
}

export const signOutReq = ({ headers }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.get('auth/sign_out', {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
