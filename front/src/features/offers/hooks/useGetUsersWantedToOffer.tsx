import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { getUsersWantedToOffer as getUsersWantedToOfferRequest } from '@/features/offers/api/getUsersWantedToOffer'
import type { User } from '@/features/users'
import { useMessage } from '@/hooks/useMessage'

export const useGetUsersWantedToOffer = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()
  const [usersWantedToOffer, setUsersWantedToOffer] = useState<Array<User>>([])

  const [loading, setLoading] = useState(false)

  const getUsersWantedToOffer = useCallback((id: string) => {
    setLoading(true)
    getUsersWantedToOfferRequest({ id })
      .then((response) => {
        setUsersWantedToOffer(response.data)
      })
      .catch(() => {
        navigate('/')
        showMessage({ message: 'オファーが存在しません', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  return { usersWantedToOffer, getUsersWantedToOffer, loading }
}
