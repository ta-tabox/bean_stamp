import type { Roaster } from '@/features/roasters'
import axios from '@/lib/axios'

type Options = {
  id: string
}

export const getRoastersFollowedByUser = ({ id }: Options) =>
  axios.get<Array<Roaster>>(`users/${id}/roasters_followed_by_user`)
