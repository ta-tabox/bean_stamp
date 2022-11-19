import type { AuthHeaders } from '@/features/auth'
import type { Roaster } from '@/features/roasters'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  id: string
}

export const getRoastersFollowedByUser = ({ headers, id }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.get<Array<Roaster>>(`users/${id}/roasters_followed_by_user`, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
