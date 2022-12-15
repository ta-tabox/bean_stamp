import type { AuthHeaders } from '@/features/auth/types'
import type { Roaster } from '@/features/roasters/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  formData: FormData
}

export const createRoaster = ({ headers, formData }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.post<Roaster>('roasters', formData, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
      'Content-Type': 'multipart/form-data',
    },
  })
}
