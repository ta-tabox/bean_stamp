import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { useCookies } from 'react-cookie'

import type { SignInParams, SignUpParams } from '@/features/auth'
import { useCurrentUser } from '@/features/auth/hooks/useCurrentUser'
import type { User } from '@/features/users'
import { useMessage } from '@/hooks/useMessage'
import client from '@/lib/client'

import type { AxiosError, AxiosResponse } from 'axios'

// apiからのレスポンスは{ data { data : User } }という階層になっている
type authResponseType = {
  data: User
}

export const useAuth = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()
  const [loading, setLoading] = useState(false)
  const { setCurrentUser, setIsSignedIn } = useCurrentUser()

  const [cookies, setCookie, removeCookie] = useCookies(['uid', 'client', 'access-token'])

  const setExpireDate = (rememberMe?: boolean) => {
    const expireDate = 14 // rememberMe期間を14日に設定
    return rememberMe ? new Date(Date.now() + expireDate * 86400e3) : undefined
  }

  const setAuthCookies = (res: AxiosResponse, rememberMe?: boolean) => {
    const expireDate = setExpireDate(rememberMe)
    setCookie('uid', res.headers.uid, { path: '/', expires: expireDate })
    setCookie('client', res.headers.client, { path: '/', expires: expireDate })
    setCookie('access-token', res.headers['access-token'], { path: '/', expires: expireDate })
  }

  const removeAuthCookies = () => {
    removeCookie('uid')
    removeCookie('client')
    removeCookie('access-token')
  }

  const signUp = useCallback((params: SignUpParams) => {
    setLoading(true)
    client
      .post('auth/', params)
      .then((res: AxiosResponse<authResponseType>) => {
        // 認証情報をcookieにセット
        setAuthCookies(res)
        setIsSignedIn(true)
        setCurrentUser(res.data.data)
        showMessage({ message: 'ユーザー登録が完了しました', type: 'success' })
        navigate('/user/home')
      })
      // TODO エラーメッセージをトーストではなくメッセージとして表示するhooksを作成する
      // エラーメッセージはstateとして保持した方がいい気がする
      .catch((err: AxiosError<{ errors: { fullMessages: Array<string> } }>) => {
        const errorMessages = err.response?.data.errors.fullMessages
        errorMessages?.map((errorMessage) => showMessage({ message: `${errorMessage}`, type: 'error' }))
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  const signIn = useCallback((params: SignInParams, rememberMe?: boolean) => {
    setLoading(true)
    client
      .post<authResponseType>('auth/sign_in', params)
      .then((res) => {
        setAuthCookies(res, rememberMe)
        setIsSignedIn(true)
        setCurrentUser(res.data.data) // グローバルステートにUserの値をセット
        showMessage({ message: 'ログインしました', type: 'success' })
        navigate('/user/home')
      })
      .catch(() => {
        showMessage({ message: 'メールアドレスもしくはパスワードが正しくありません', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  const signOut = useCallback(() => {
    setLoading(true)
    client
      .get('auth/sign_out', {
        headers: {
          uid: cookies.uid as string,
          client: cookies.client as string,
          'access-token': cookies['access-token'] as string,
        },
      })
      .then(() => {
        // 認証情報をのcookieを削除
        removeAuthCookies()
        setIsSignedIn(false)
        setCurrentUser(null) // LoginUserStateを削除
        showMessage({ message: 'ログアウトしました', type: 'success' })
        navigate('/')
      })
      .catch(() => {
        showMessage({ message: 'ログアウトに失敗しました', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  // アカウントの削除
  const deleteUser = useCallback(() => {
    setLoading(true)
    client
      .delete('auth', {
        headers: {
          uid: cookies.uid as string,
          client: cookies.client as string,
          'access-token': cookies['access-token'] as string,
        },
      })
      .then(() => {
        // 認証情報をのcookieを削除
        removeAuthCookies()
        setIsSignedIn(false)
        setCurrentUser(null)
        showMessage({ message: 'アカウントを削除しました', type: 'success' })
        navigate('/')
      })
      .catch(() => {
        showMessage({ message: 'アカウントの削除に失敗しました', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  return { signUp, signIn, signOut, deleteUser, loading, setAuthCookies, removeAuthCookies }
}
