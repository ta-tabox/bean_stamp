import type { AuthHeaders } from '@/features/auth'
import type { User } from '@/features/users'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  id: string
}

export const getUsersFollowingToRoaster = ({ headers, id }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.get<Array<User>>(`roasters/${id}/followers`, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
