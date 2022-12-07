import { useState } from 'react'

import { useRecoilValue, useSetRecoilState } from 'recoil'

import { currentRoasterState } from '@/features/roasters/stores/currentRoasterState'
import { isRoasterState } from '@/features/roasters/stores/isRoasterState'
import type { Roaster } from '@/features/roasters/types'

import type { SetterOrUpdater } from 'recoil'

export const useCurrentRoaster = () => {
  const [loading, setLoading] = useState(false)

  // Recoilでグローバルステートを定義
  const currentRoaster = useRecoilValue(currentRoasterState) // Getterを定義
  const setCurrentRoaster: SetterOrUpdater<Roaster | null> = useSetRecoilState(currentRoasterState) // Setter, Updaterを定義

  // SignInの状態を保持
  const isRoaster = useRecoilValue(isRoasterState)
  const setIsRoaster = useSetRecoilState(isRoasterState)

  return { currentRoaster, setCurrentRoaster, isRoaster, setIsRoaster, loading }
}
