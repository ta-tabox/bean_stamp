import type { Roaster } from '@/features/roasters'
import { BackendApiWithAuth } from '@/lib/axios'

type Options = {
  id: string
}

export const getRoastersFollowedByUser = ({ id }: Options) =>
  BackendApiWithAuth.get<Array<Roaster>>(`users/${id}/roasters_followed_by_user`)
