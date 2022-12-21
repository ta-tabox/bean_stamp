import type { User } from '@/features/users'
import { BackendApiWithAuth } from '@/lib/axios'

type Options = {
  id: string
}

export const getUsersFollowingToRoaster = ({ id }: Options) =>
  BackendApiWithAuth.get<Array<User>>(`roasters/${id}/followers`)
