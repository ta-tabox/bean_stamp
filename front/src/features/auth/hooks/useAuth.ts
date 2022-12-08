import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

import type { SignInParams, SignUpParams } from '@/features/auth'
import { deleteUserReq } from '@/features/auth/api/deleteUser'
import { signInWithEmailAndPassword } from '@/features/auth/api/signIn'
import { signOutReq } from '@/features/auth/api/signOut'
import { signUpWithSignUpParams } from '@/features/auth/api/signUp'
import { useAuthCookies } from '@/features/auth/hooks/useAuthCookies'
import { useAuthHeaders } from '@/features/auth/hooks/useAuthHeaders'
import { useSignedInUser } from '@/features/auth/hooks/useSignedInUser'
import { useCurrentRoaster } from '@/features/roasters'
import { useErrorNotification } from '@/hooks/useErrorNotification'
import { useMessage } from '@/hooks/useMessage'
import type { ErrorResponse } from '@/types'

import type { AxiosError } from 'axios'

export const useAuth = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()
  const [loading, setLoading] = useState(false)

  const { signedInUser, setIsSignedIn, setSignedInUser } = useSignedInUser()
  const { setCurrentRoaster } = useCurrentRoaster()
  const { setAuthCookies, removeAuthCookies } = useAuthCookies()
  const { authHeaders } = useAuthHeaders()
  const { setErrorNotifications } = useErrorNotification()

  // サインアップ
  type SignUpOptions = {
    params: SignUpParams
  }
  const signUp = async ({ params }: SignUpOptions) => {
    setLoading(true)
    await signUpWithSignUpParams({ params })
      .then((res) => {
        // 認証情報をcookieにセット
        setAuthCookies({ res })
        setIsSignedIn(true)
        setSignedInUser(res.data.data) // グローバルステートにUserの値をセット
        return Promise.resolve(signedInUser)
      })
      .catch((err: AxiosError<ErrorResponse>) => {
        const errorMessages = err.response?.data.errors.fullMessages
        if (errorMessages) {
          setErrorNotifications(errorMessages)
        }
        return Promise.reject(err)
      })
      .finally(() => {
        setLoading(false)
      })
  }

  // サインイン
  type SignInOptions = {
    params: SignInParams
    isRememberMe?: boolean
  }

  const signIn = async ({ params, isRememberMe }: SignInOptions) => {
    setLoading(true)
    await signInWithEmailAndPassword({ params })
      .then((res) => {
        setAuthCookies({ res, isRememberMe })
        setIsSignedIn(true)
        setSignedInUser(res.data.data) // グローバルステートにUserの値をセット
        return Promise.resolve(signedInUser)
      })
      .catch((err: AxiosError<{ errors: Array<string> }>) => {
        const errorMessages = err.response?.data.errors
        if (errorMessages) {
          setErrorNotifications(errorMessages)
        }
        return Promise.reject(err)
      })
      .finally(() => {
        setLoading(false)
      })
  }

  // サインアウト
  const signOut = () => {
    setLoading(true)

    signOutReq({ headers: authHeaders })
      .then(() => {
        // 認証情報をのcookieを削除
        removeAuthCookies()
        setIsSignedIn(false)
        setSignedInUser(null) // SignedInUserStateを削除
        setCurrentRoaster(null) // CurrentRoasterStateを削除
        showMessage({ message: 'ログアウトしました', type: 'success' })
        navigate('/auth/signin')
      })
      .catch(() => {
        showMessage({ message: 'ログアウトに失敗しました', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }

  // アカウントの削除
  const deleteUser = async () => {
    setLoading(true)

    await deleteUserReq({ headers: authHeaders })
      .then(() => {
        // 認証情報をのcookieを削除
        removeAuthCookies()
        setIsSignedIn(false)
        setSignedInUser(null) // SignedInUserStateを削除
        setCurrentRoaster(null) // CurrentRoasterStateを削除
        return Promise.resolve(null)
      })
      .catch((err) => Promise.reject(err))
      .finally(() => {
        setLoading(false)
      })
  }

  return { signUp, signIn, signOut, deleteUser, loading, authHeaders }
}
