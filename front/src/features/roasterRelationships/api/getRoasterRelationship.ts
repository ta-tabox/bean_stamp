import type { AuthHeaders } from '@/features/auth'
import type { GetRoasterRelationshipResponse } from '@/features/roasterRelationships/types'
import axios from '@/lib/axios'

type Options = {
  headers: AuthHeaders
  roasterId: string
}

export const getRoasterRelationship = ({ headers, roasterId }: Options) => {
  const { uid, client, accessToken } = headers

  return axios.get<GetRoasterRelationshipResponse>(`roaster_relationships/`, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
    },
    params: {
      roaster_id: roasterId,
    },
  })
}
