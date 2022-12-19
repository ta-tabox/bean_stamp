import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { useAuth } from '@/features/auth'
import { getUsersFollowingToRoaster as getUsersFollowingToRoasterRequest } from '@/features/roasters/api/getUsersFollowingToRoaster'
import { useUsersFollowingToRoaster } from '@/features/roasters/hooks/useUsersFollowingToRoaster'
import { useMessage } from '@/hooks/useMessage'

export const useGetUsersFollowingToRoaster = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()
  const { authHeaders } = useAuth()
  const { usersFollowingToRoaster, setUsersFollowingToRoaster } = useUsersFollowingToRoaster()

  const [loading, setLoading] = useState(false)

  const getUsersFollowingToRoaster = useCallback((id: string) => {
    setLoading(true)
    getUsersFollowingToRoasterRequest({ headers: authHeaders, id })
      .then((response) => {
        setUsersFollowingToRoaster(response.data)
      })
      .catch(() => {
        navigate('/')
        showMessage({ message: 'ロースターが存在しません', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  return { usersFollowingToRoaster, getUsersFollowingToRoaster, loading }
}
