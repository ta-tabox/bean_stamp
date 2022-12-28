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

  const getBeans = () => {
    setLoading(true)
    getBeansRequest()
      .then((response) => {
        setBeans(response.data)
      })
      .catch(() => {
        navigate('/')
        showMessage({ message: 'ロースターが存在しません', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }

  return { beans, getBeans, loading }
}
