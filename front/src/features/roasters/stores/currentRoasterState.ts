import { atom } from 'recoil'

import type { Roaster } from '@/features/roasters/types'

// TODO リロード時にcurrentRoasterによる条件分岐がうまくいかない→sessionStorageに保存する？
// signedInUserの所属するroasterを保持する
export const currentRoasterState = atom<Roaster | null>({
  key: 'currentRoasterState',
  default: null,
})
