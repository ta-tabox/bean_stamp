import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { getLikes as getLikesRequest } from '@/features/likes/api/getLikes'
import { getLikesWithSearch } from '@/features/likes/api/getLikesWithSearch'
import { useLikes } from '@/features/likes/hooks/useLikes'
import { useMessage } from '@/hooks/useMessage'
import { usePagination } from '@/hooks/usePagination'

export const useGetLikes = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()

  const [loading, setLoading] = useState(false)
  const { setPagination } = usePagination()

  const { likes, setLikes } = useLikes()

  type GetLikes = {
    page: string | null
    status?: string | null
  }
  const getLikes = async ({ page, status }: GetLikes) => {
    setLoading(true)
    let response
    try {
      if (status) {
        response = await getLikesWithSearch({ page, status })
      } else {
        response = await getLikesRequest({ page })
      }
    } catch {
      navigate('/')
      showMessage({ message: 'お気に入りの取得に失敗しました', type: 'error' })
      return
    } finally {
      setLoading(false)
    }
    setLikes(response.data)
    setPagination({ headers: response.headers })
  }

  return { likes, getLikes, setLikes, loading }
}
