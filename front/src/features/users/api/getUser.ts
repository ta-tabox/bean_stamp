import type { User } from '@/features/users/types'
import axios from '@/lib/axios'

type Options = {
  id: string
}

export const getUser = ({ id }: Options) => axios.get<User>(`/users/${id}`)
