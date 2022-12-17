import type { AuthHeaders } from '@/features/auth/types'
import type { RoasterRelationshipResponse } from '@/features/roaster_relationships/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  roasterId: number
}

export const createRoasterRelationship = ({ headers, roasterId }: Options) => {
  const { uid, client, accessToken } = headers

  const params = {
    roaster_id: roasterId,
  }

  return axios.post<RoasterRelationshipResponse>('roaster_relationships', params, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
  })
}
