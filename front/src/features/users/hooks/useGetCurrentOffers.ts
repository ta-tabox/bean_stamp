import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

import type { Offer } from '@/features/offers/types'
import { getCurrentOffers as getCurrentOffersRequest } from '@/features/users/api/getCurrentOffers'
import { useMessage } from '@/hooks/useMessage'

export const useGetCurrentOffers = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()

  const [loading, setLoading] = useState(false)
  const [offers, setOffers] = useState<Array<Offer>>()
  const [currentPage, setCurrentPage] = useState<number>()
  const [totalPage, setTotalPage] = useState<number>()

  type GetCurrentOffers = {
    page: string | null
  }

  const getCurrentOffers = ({ page }: GetCurrentOffers) => {
    setLoading(true)
    getCurrentOffersRequest({ page })
      .then((response) => {
        setOffers(response.data)
        const newCurrentPage = parseInt(response.headers['current-page'], 10)
        const newTotalPage = parseInt(response.headers['total-pages'], 10)
        setCurrentPage(newCurrentPage)
        setTotalPage(newTotalPage)
      })
      .catch(() => {
        navigate('/')
        showMessage({ message: 'オファーの取得に失敗しました', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }

  return { currentOffers: offers, getCurrentOffers, loading, currentPage, totalPage }
}
