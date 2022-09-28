import { atom } from 'recoil'

import type { User } from '@/types/api/user'

// Userタイプの継承
export type LoginUserStateType = User & {
  isAdmin: boolean
}

// atomで指定した型はdefault内のとセットしたstateに影響
export const loginUserState = atom<LoginUserStateType | null>({
  key: 'loginUserState',
  default: null,
})
