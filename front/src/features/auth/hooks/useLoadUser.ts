import { getSignInUser } from '@/features/auth/api/getSignInUser'
import { useAuthCookies } from '@/features/auth/hooks/useAuthCookies'
import { useAuthHeaders } from '@/features/auth/hooks/useAuthHeaders'
import { useResetStates } from '@/features/auth/hooks/useResetStates'
import { useSignedInUser } from '@/features/auth/hooks/useSignedInUser'
import { useCurrentRoaster } from '@/features/roasters'

export const useLoadUser = () => {
  const { setIsSignedIn, setSignedInUser, setIsBelongingToRoaster } = useSignedInUser()
  const { setCurrentRoaster } = useCurrentRoaster()
  const { authHeaders } = useAuthHeaders()
  const { removeAuthCookies } = useAuthCookies()
  const { resetStates } = useResetStates()

  // ログインユーザーの読み込み
  const loadUser = async () => {
    await getSignInUser({ headers: authHeaders })
      .then((res) => {
        if (res.data.isLogin) {
          setIsSignedIn(true)
          setSignedInUser(res.data.user)
          if (res.data.roaster) {
            setIsBelongingToRoaster(true)
            setCurrentRoaster(res.data.roaster)
          }
        } else {
          removeAuthCookies()
          resetStates()
        }
      })
      .catch(() => {
        removeAuthCookies()
        resetStates()
      })
  }
  return { loadUser }
}
