import { useRecoilValue, useSetRecoilState } from 'recoil'

import { isSignedInState } from '@/features/auth/stores/isSignedInState'
import { signedInUserState } from '@/features/auth/stores/signedInUserState'
import type { User } from '@/features/users'

import type { SetterOrUpdater } from 'recoil'

export const useSignedInUser = () => {
  // Recoilでグローバルステートを定義
  const signedInUser = useRecoilValue(signedInUserState) // Getterを定義
  const setSignedInUser: SetterOrUpdater<User | null> = useSetRecoilState(signedInUserState) // Setter, Updaterを定義

  // SignInの状態を保持
  const isSignedIn = useRecoilValue(isSignedInState)
  const setIsSignedIn = useSetRecoilState(isSignedInState)

  return { signedInUser, setSignedInUser, isSignedIn, setIsSignedIn }
}
