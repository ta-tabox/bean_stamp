import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { getWants as getWantsRequest } from '@/features/wants/api/getWants'
import { getWantsWithSearch } from '@/features/wants/api/getWantsWithSearch'
import type { Want } from '@/features/wants/type'
import { useMessage } from '@/hooks/useMessage'
import { usePagination } from '@/hooks/usePagination'

export const useGetWants = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()

  const [wants, setWants] = useState<Array<Want>>([])
  const [loading, setLoading] = useState(false)
  const { setPagination } = usePagination()

  type GetWants = {
    page: string | null
    status?: string | null
  }
  const getWants = async ({ page, status }: GetWants) => {
    setLoading(true)
    let response
    try {
      if (status) {
        response = await getWantsWithSearch({ page, status })
      } else {
        response = await getWantsRequest({ page })
      }
    } catch {
      navigate('/')
      showMessage({ message: 'ウォンツの取得に失敗しました', type: 'error' })
      return
    } finally {
      setLoading(false)
    }

    setWants(response.data)
    setPagination({ headers: response.headers })
  }

  return { wants, getWants, loading }
}
