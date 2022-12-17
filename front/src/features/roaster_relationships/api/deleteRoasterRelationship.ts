import type { AuthHeaders } from '@/features/auth/types'
import type { RoasterRelationshipResponse } from '@/features/roaster_relationships/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  id: string
}

export const deleteRoasterRelationship = ({ headers, id }: Options) => {
  const { uid, client, accessToken } = headers
  return axios.delete<RoasterRelationshipResponse>(`roaster_relationships/${id}`, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
