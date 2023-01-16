import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { getOffers as getOffersRequest } from '@/features/offers/api/getOffers'
import type { Offer } from '@/features/offers/types'
import { useMessage } from '@/hooks/useMessage'

export const useGetOffers = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()

  const [offers, setOffers] = useState<Array<Offer>>([])
  const [loading, setLoading] = useState(false)
  const [currentPage, setCurrentPage] = useState<number>()
  const [totalPage, setTotalPage] = useState<number>()

  type GetOffers = {
    page: string | null
  }
  const getOffers = ({ page }: GetOffers) => {
    setLoading(true)
    getOffersRequest({ page })
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

  return { offers, getOffers, currentPage, totalPage, loading }
}
