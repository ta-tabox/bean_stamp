import type { AuthHeaders } from '@/features/auth/types'
import type { Roaster } from '@/features/roasters/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  id: string
  formData: FormData
}

export const updateRoaster = ({ headers, id, formData }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.put<Roaster>(`roasters/${id}`, formData, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
      'Content-Type': 'multipart/form-data',
    },
  })
}
