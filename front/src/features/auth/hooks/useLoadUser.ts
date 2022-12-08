import { getSignInUser } from '@/features/auth/api/getSignInUser'
import { useAuthCookies } from '@/features/auth/hooks/useAuthCookies'
import { useAuthHeaders } from '@/features/auth/hooks/useAuthHeaders'
import { useSignedInUser } from '@/features/auth/hooks/useSignedInUser'
import { useCurrentRoaster } from '@/features/roasters'

export const useLoadUser = () => {
  const { setIsSignedIn, setSignedInUser } = useSignedInUser()
  const { setCurrentRoaster } = useCurrentRoaster()
  const { authHeaders } = useAuthHeaders()
  const { removeAuthCookies } = useAuthCookies()

  // ログインユーザーの読み込み
  const loadUser = () => {
    getSignInUser({ headers: authHeaders })
      .then((res) => {
        if (res.data.isLogin) {
          setIsSignedIn(true)
          setSignedInUser(res.data.user)
          setCurrentRoaster(res.data.roaster)
        } else {
          removeAuthCookies()
          setIsSignedIn(false)
          setSignedInUser(null) // SignedInUserStateを削除
          setCurrentRoaster(null) // CurrentRoasterStateを削除
        }
      })
      .catch(() => {
        removeAuthCookies()
        setIsSignedIn(false)
        setSignedInUser(null) // SignedInUserStateを削除
        setCurrentRoaster(null) // CurrentRoasterStateを削除
      })
  }
  return { loadUser }
}
