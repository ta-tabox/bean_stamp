import type { AuthHeaders } from '@/features/auth'
import type { Roaster } from '@/features/roasters/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  id: string
}

export const getRoaster = ({ headers, id }: Options) => {
  const { uid, client, accessToken } = headers

  return axios.get<Roaster>(`/roasters/${id}`, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
