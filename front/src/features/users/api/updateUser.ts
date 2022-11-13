import type { AuthHeaders, UserResponse } from '@/features/auth/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  formData: FormData
}

export const updateUser = ({ headers, formData }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.patch<UserResponse>('auth', formData, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
      'Content-Type': 'multipart/form-data',
    },
  })
}
