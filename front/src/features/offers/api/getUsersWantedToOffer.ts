import type { User } from '@/features/users'
import { BackendApiWithAuth } from '@/lib/axios'

type Options = {
  id: string
}

export const getUsersWantedToOffer = ({ id }: Options) =>
  BackendApiWithAuth.get<Array<User>>(`offers/${id}/wanted_users`)
