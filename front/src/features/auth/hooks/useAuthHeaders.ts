import { useCookies } from 'react-cookie'

import type { AuthHeaders } from '@/features/auth/types'

// WARNING axiosインスタンス作成時に実装するため、不使用となる
export const useAuthHeaders = () => {
  const [cookies] = useCookies(['uid', 'client', 'access-token'])

  // 認証関係のHeaderをセットする
  const setAuthHeaders = (): AuthHeaders => ({
    uid: cookies.uid as string,
    client: cookies.client as string,
    accessToken: cookies['access-token'] as string,
  })

  // devise-token-authで使用する認証トークン
  const authHeaders = setAuthHeaders()

  return { authHeaders }
}
