import { useState } from 'react'

import { useRecoilValue, useSetRecoilState } from 'recoil'

import { getSignInUser } from '@/features/auth/api/getSignInUser'
import { useAuthCookies } from '@/features/auth/hooks/useAuthCookies'
import { useAuthHeaders } from '@/features/auth/hooks/useAuthHeaders'
import { isSignedInState } from '@/features/auth/stores/isSignedInState'
import { signedInUserState } from '@/features/auth/stores/signedInUserState'
import type { User } from '@/features/users'

import type { SetterOrUpdater } from 'recoil'

export const useSignedInUser = () => {
  const [loading, setLoading] = useState(false)

  const { removeAuthCookies } = useAuthCookies()
  const { authHeaders } = useAuthHeaders()

  // Recoilでグローバルステートを定義
  const signedInUser = useRecoilValue(signedInUserState) // Getterを定義
  const setSignedInUser: SetterOrUpdater<User | null> = useSetRecoilState(signedInUserState) // Setter, Updaterを定義

  // SignInの状態を保持
  const isSignedIn = useRecoilValue(isSignedInState)
  const setIsSignedIn = useSetRecoilState(isSignedInState)

  // ログインユーザーの読み込み
  const loadUser = () => {
    setLoading(true)

    getSignInUser({ headers: authHeaders })
      .then((res) => {
        if (res.data.isLogin) {
          setIsSignedIn(true)
          setSignedInUser(res.data.data)
        } else {
          removeAuthCookies()
          setIsSignedIn(false)
          setSignedInUser(null) // LoginUserStateを削除
        }
      })
      .catch(() => {
        removeAuthCookies()
        setIsSignedIn(false)
        setSignedInUser(null) // LoginUserStateを削除
      })
      .finally(() => {
        setLoading(false)
      })
  }

  return { loadUser, loading, signedInUser, setSignedInUser, isSignedIn, setIsSignedIn }
}
