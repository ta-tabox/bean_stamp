import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { useAuth } from '@/features/auth'
import { getUsersFollowingToRoaster as getUsersFollowingToRoasterRequest } from '@/features/roasters/api/getUsersFollowingToRoaster'
import type { User } from '@/features/users'
import { useMessage } from '@/hooks/useMessage'

export const useGetUsersFollowingToRoaster = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()
  const { authHeaders } = useAuth()

  const [loading, setLoading] = useState(false)
  const [users, setUsers] = useState<Array<User>>()

  const getUsersFollowingToRoaster = useCallback((id: string) => {
    setLoading(true)
    getUsersFollowingToRoasterRequest({ headers: authHeaders, id })
      .then((response) => {
        setUsers(response.data)
      })
      .catch(() => {
        navigate('/')
        showMessage({ message: 'ロースターが存在しません', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  return { users, getUsersFollowingToRoaster, loading }
}
