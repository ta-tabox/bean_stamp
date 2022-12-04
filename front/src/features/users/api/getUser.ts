import type { AuthHeaders } from '@/features/auth'
import type { User } from '@/features/users/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  id: string
}

export const getUser = ({ headers, id }: Options) => {
  const { uid, client, accessToken } = headers

  return axios.get<User>(`/users/${id}`, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
