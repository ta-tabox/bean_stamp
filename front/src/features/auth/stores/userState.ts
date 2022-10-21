import { atom } from 'recoil'

import type { User } from '@/features/users/types'

// atomで指定した型はdefault内のとセットしたstateに影響
export const userState = atom<User | null>({
  key: 'userState',
  default: null,
})
