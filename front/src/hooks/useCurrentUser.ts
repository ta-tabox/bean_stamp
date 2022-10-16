import { useRecoilValue, useSetRecoilState } from 'recoil'

import { currentUserState } from '@/store/currentUserState'
import { isSignedInState } from '@/store/isSignedInState'
import type { User } from '@/types'

import type { SetterOrUpdater } from 'recoil'

export const useCurrentUser = () => {
  // Getterを定義
  const currentUser = useRecoilValue(currentUserState)
  // Setter, Updaterを定義
  const setCurrentUser: SetterOrUpdater<User | null> = useSetRecoilState(currentUserState)

  // SignInの状態を保持
  const isSignedIn = useRecoilValue(isSignedInState)
  const setIsSignedIn = useSetRecoilState(isSignedInState)

  return { currentUser, setCurrentUser, isSignedIn, setIsSignedIn }
}
