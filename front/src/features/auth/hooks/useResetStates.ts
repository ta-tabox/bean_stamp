import { useSignedInUser } from '@/features/auth/hooks/useSignedInUser'
import { useRecommendedOffers } from '@/features/offers/hooks/useRecommendedOffers'
import { useCurrentRoaster } from '@/features/roasters'

export const useResetStates = () => {
  const { setIsSignedIn, setSignedInUser, setIsBelongingToRoaster } = useSignedInUser()
  const { setCurrentRoaster, setIsRoaster } = useCurrentRoaster()
  const { setRecommendedOffers, setRecommendedOffersPool } = useRecommendedOffers()

  const resetStates = () => {
    setIsSignedIn(false) // IsSignedInStateを初期化
    setSignedInUser(null) // SignedInUserStateを初期化
    setIsBelongingToRoaster(false) // IsBelongingToRoasterStateを初期化
    setCurrentRoaster(null) // CurrentRoasterStateを初期化
    setIsRoaster(false) // IsRoasterStateを初期化
    setRecommendedOffers([]) // おすすめのオファーを初期化
    setRecommendedOffersPool([]) // おすすめのオファーのプールを初期化
    // TODO recoil管理下のステートを追加する
  }

  return { resetStates }
}
