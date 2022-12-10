import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { useAuth } from '@/features/auth'
import { getRoaster as getRoasterRequest } from '@/features/roasters/api/getRoaster'
import type { Roaster } from '@/features/roasters/types'
import { useMessage } from '@/hooks/useMessage'

export const useGetRoaster = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()
  const { authHeaders } = useAuth()

  const [loading, setLoading] = useState(false)
  const [roaster, setRoaster] = useState<Roaster>()

  const getRoaster = useCallback((id: string) => {
    setLoading(true)
    getRoasterRequest({ headers: authHeaders, id })
      .then((response) => {
        setRoaster(response.data)
      })
      .catch(() => {
        navigate('/')
        showMessage({ message: 'ロースターが存在しません', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  return { roaster, getRoaster, loading }
}
