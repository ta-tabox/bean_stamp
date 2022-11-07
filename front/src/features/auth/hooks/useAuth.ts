import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { useCookies } from 'react-cookie'
import { useRecoilValue, useSetRecoilState } from 'recoil'

import type { AuthHeaders, SignInParams, SignUpParams } from '@/features/auth'
import { deleteUserReq } from '@/features/auth/api/deleteUser'
import { getSignInUser } from '@/features/auth/api/getSignInUser'
import { signInWithEmailAndPassword } from '@/features/auth/api/signIn'
import { signOutReq } from '@/features/auth/api/signOut'
import { signUpWithSignUpParams } from '@/features/auth/api/signUp'
import { isSignedInState } from '@/features/auth/stores/isSignedInState'
import { userState } from '@/features/auth/stores/userState'
import type { User } from '@/features/users'
import { useMessage } from '@/hooks/useMessage'
import { useNotification } from '@/hooks/useNotification'
import type { ErrorResponse } from '@/types'

import type { AxiosError, AxiosResponse } from 'axios'
import type { SetterOrUpdater } from 'recoil'

export const useAuth = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()
  const [loading, setLoading] = useState(false)
  const [cookies, setCookie, removeCookie] = useCookies(['uid', 'client', 'access-token'])

  const { setNotifications, setNotificationMessagesWithType } = useNotification()

  const setExpireDate = (isRememberMe?: boolean) => {
    const expireDate = 14 // rememberMe期間を14日に設定
    return isRememberMe ? new Date(Date.now() + expireDate * 86400e3) : undefined
  }

  const setAuthCookies = (res: AxiosResponse, isRememberMe?: boolean) => {
    const expireDate = setExpireDate(isRememberMe)
    setCookie('uid', res.headers.uid, { path: '/', expires: expireDate })
    setCookie('client', res.headers.client, { path: '/', expires: expireDate })
    setCookie('access-token', res.headers['access-token'], { path: '/', expires: expireDate })
  }

  const removeAuthCookies = () => {
    removeCookie('uid')
    removeCookie('client')
    removeCookie('access-token')
  }

  const setAuthHeaders = (): AuthHeaders => ({
    uid: cookies.uid as string,
    client: cookies.client as string,
    accessToken: cookies['access-token'] as string,
  })

  // Recoilでグローバルステートを定義
  // Getterを定義
  const user = useRecoilValue(userState)
  // Setter, Updaterを定義
  const setUser: SetterOrUpdater<User | null> = useSetRecoilState(userState)

  // SignInの状態を保持
  const isSignedIn = useRecoilValue(isSignedInState)
  const setIsSignedIn = useSetRecoilState(isSignedInState)

  // サインアップ
  const signUp = async (params: SignUpParams) => {
    setLoading(true)
    await signUpWithSignUpParams(params)
      .then((res) => {
        // 認証情報をcookieにセット
        setAuthCookies(res)
        setIsSignedIn(true)
        setUser(res.data.data)
        return Promise.resolve(user)
      })
      .catch((err: AxiosError<ErrorResponse>) => {
        const errorMessages = err.response?.data.errors.fullMessages
        const notificationMessages = errorMessages ? setNotificationMessagesWithType(errorMessages, 'error') : null
        setNotifications(notificationMessages)
        return Promise.reject(err)
      })
      .finally(() => {
        setLoading(false)
      })
  }

  // サインイン
  const signIn = async (params: SignInParams, rememberMe?: boolean) => {
    setLoading(true)
    await signInWithEmailAndPassword(params)
      .then((res) => {
        setAuthCookies(res, rememberMe)
        setIsSignedIn(true)
        setUser(res.data.data) // グローバルステートにUserの値をセット
        return Promise.resolve(user)
      })
      .catch((err: AxiosError<{ errors: Array<string> }>) => {
        const errorMessages = err.response?.data.errors
        const notificationMessages = errorMessages ? setNotificationMessagesWithType(errorMessages, 'error') : null
        setNotifications(notificationMessages)
        return Promise.reject(err)
      })
      .finally(() => {
        setLoading(false)
      })
  }

  // サインアウト
  const signOut = () => {
    setLoading(true)
    const headers = setAuthHeaders()

    signOutReq(headers)
      .then(() => {
        // 認証情報をのcookieを削除
        removeAuthCookies()
        setIsSignedIn(false)
        setUser(null) // LoginUserStateを削除
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
    const headers = setAuthHeaders()

    await deleteUserReq(headers)
      .then(() => {
        // 認証情報をのcookieを削除
        removeAuthCookies()
        setIsSignedIn(false)
        setUser(null)
        return Promise.resolve(null)
      })
      .catch((err) => Promise.reject(err))
      .finally(() => {
        setLoading(false)
      })
  }

  const loadUser = () => {
    setLoading(true)
    const headers = setAuthHeaders()

    getSignInUser(headers)
      .then((res) => {
        if (res.data.isLogin) {
          setIsSignedIn(true)
          setUser(res.data.data)
        } else {
          removeAuthCookies()
          setIsSignedIn(false)
          setUser(null) // LoginUserStateを削除
        }
      })
      .catch(() => {
        removeAuthCookies()
        setIsSignedIn(false)
        setUser(null) // LoginUserStateを削除
      })
      .finally(() => {
        setLoading(false)
      })
  }

  return { signUp, signIn, signOut, deleteUser, loadUser, loading, user, isSignedIn, setAuthHeaders }
}
