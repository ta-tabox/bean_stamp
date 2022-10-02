import { atom } from 'recoil'

import type { User } from '@/types/api/user'

// atomで指定した型はdefault内のとセットしたstateに影響
export const loginUserState = atom<User | null>({
  key: 'loginUserState',
  default: null,
})
