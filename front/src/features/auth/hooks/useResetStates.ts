import { useSignedInUser } from '@/features/auth/hooks/useSignedInUser'
import { useCurrentRoaster } from '@/features/roasters' // TODO 循環参照の原因コード

export const useResetStates = () => {
  const { setIsSignedIn, setSignedInUser, setIsBelongingToRoaster } = useSignedInUser()
  const { setCurrentRoaster, setIsRoaster } = useCurrentRoaster()

  const resetStates = () => {
    setIsSignedIn(false) // IsSignedInStateを初期化
    setSignedInUser(null) // SignedInUserStateを初期化
    setIsBelongingToRoaster(false) // IsBelongingToRoasterStateを初期化
    setCurrentRoaster(null) // CurrentRoasterStateを初期化
    setIsRoaster(false) // IsRoasterStateを初期化
  }

  return { resetStates }
}
