import { useRecoilValue, useSetRecoilState } from 'recoil'

import { wantsStatsState } from '@/features/wants/stores/wantsStatsState'

export const useWantsStats = () => {
  const wantsStats = useRecoilValue(wantsStatsState) // Getterを定義
  const setWantsStats = useSetRecoilState(wantsStatsState) // Setter, Updaterを定義

  return { wantsStats, setWantsStats }
}
