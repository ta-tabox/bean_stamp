import type { AuthHeaders } from '@/features/auth/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  id: string
}

export const deleteRoaster = ({ headers, id }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.delete(`roasters/${id}`, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
