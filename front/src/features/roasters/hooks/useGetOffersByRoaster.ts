import { useState } from 'react'

import type { Offer } from '@/features/offers/types'
import { getOffersByRoaster as getOffersByRoasterRequest } from '@/features/roasters/api/getOffersByRoaster'
import { useMessage } from '@/hooks/useMessage'

export const useGetOffersByRoaster = () => {
  const { showMessage } = useMessage()

  const [offersByRoaster, setOffersByRoaster] = useState<Array<Offer>>([])
  const [loading, setLoading] = useState(false)
  const [currentPage, setCurrentPage] = useState<number>()
  const [totalPage, setTotalPage] = useState<number>()

  type GetOffers = {
    id: string
    page: string | null
  }
  const getOffersByRoaster = ({ id, page }: GetOffers) => {
    setLoading(true)
    getOffersByRoasterRequest({ id, page })
      .then((response) => {
        setOffersByRoaster(response.data)
        const newCurrentPage = parseInt(response.headers['current-page'], 10)
        const newTotalPage = parseInt(response.headers['total-pages'], 10)
        setCurrentPage(newCurrentPage)
        setTotalPage(newTotalPage)
      })
      .catch(() => {
        showMessage({ message: 'オファーの取得に失敗しました', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }

  return { offersByRoaster, getOffersByRoaster, currentPage, totalPage, loading }
}
