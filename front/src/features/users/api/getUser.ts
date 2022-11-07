import type { AuthHeaders } from '@/features/auth'
import type { User } from '@/features/users/types'
import axios from '@/lib/axios'

export const getUser = (headers: AuthHeaders, id: string) => {
  const { uid, client, accessToken } = headers

  return axios.get<User>(`/users/${id}`, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
