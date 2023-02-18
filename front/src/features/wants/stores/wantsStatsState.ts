import { atom } from 'recoil'

import type { WantsStats } from '@/features/wants/types'

type WantsStatsState = WantsStats | null

export const wantsStatsState = atom<WantsStatsState>({
  key: 'wantsStatsState',
  default: null,
})
