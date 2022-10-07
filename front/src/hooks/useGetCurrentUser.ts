import { useCookies } from 'react-cookie'

import { useCurrentUser } from '@/hooks/useCurrentUser'
import client from '@/lib/api/client'
import type { User } from '@/types/api/user'

type authResponseType = {
  isLogin: boolean
  data: User
}

export const useGetCurrentUser = () => {
  const { setCurrentUser, setIsSignedIn } = useCurrentUser()
  const [cookies, , removeCookie] = useCookies(['access-token', 'client', 'uid'])

  const getCurrentUser = () => {
    if (!cookies['access-token'] || !cookies.client || !cookies.uid) {
      setIsSignedIn(false)
      setCurrentUser(null) // LoginUserStateを削除
    } else {
      client
        .get<authResponseType>('/auth/sessions', {
          headers: {
            uid: cookies.uid as string,
            client: cookies.client as string,
            'access-token': cookies['access-token'] as string,
          },
        })
        .then((res) => {
          if (res.data.isLogin) {
            setIsSignedIn(true)
            setCurrentUser(res.data.data)
          } else {
            removeCookie('uid')
            removeCookie('client')
            removeCookie('access-token')
            setIsSignedIn(false)
            setCurrentUser(null) // LoginUserStateを削除
          }
        })
        .catch(() => {
          removeCookie('uid')
          removeCookie('client')
          removeCookie('access-token')
          setIsSignedIn(false)
          setCurrentUser(null) // LoginUserStateを削除
        })
    }
  }
  return { getCurrentUser }
}
