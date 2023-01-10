import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { getBeans as getBeansRequest } from '@/features/beans/api/getBeans'
import type { Bean } from '@/features/beans/types'
import { useMessage } from '@/hooks/useMessage'

export const useGetBeans = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()

  const [beans, setBeans] = useState<Array<Bean>>([])
  const [loading, setLoading] = useState(false)
  const [currentPage, setCurrentPage] = useState<number>()
  const [totalPage, setTotalPage] = useState<number>()

  type GetBeans = {
    page: string | null
  }
  const getBeans = ({ page }: GetBeans) => {
    setLoading(true)
    getBeansRequest({ page })
      .then((response) => {
        setBeans(response.data)
        const newCurrentPage = parseInt(response.headers['current-page'], 10)
        const newTotalPage = parseInt(response.headers['total-pages'], 10)
        setCurrentPage(newCurrentPage)
        setTotalPage(newTotalPage)
      })
      .catch(() => {
        navigate('/')
        showMessage({ message: 'コーヒー豆が存在しません', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }

  return { beans, getBeans, currentPage, totalPage, loading }
}
