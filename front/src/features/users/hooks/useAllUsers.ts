import { useCallback, useState } from 'react'

import axios from 'axios'

import type { User } from '@/features/users'
import { useMessage } from '@/hooks/useMessage'

// WARNING 不使用、参考にするのが終了したら消す
export const useAllUsers = () => {
  const { showMessage } = useMessage()
  const [loading, setLoading] = useState(false)
  const [users, setUsers] = useState<Array<User>>([])

  const getUsers = useCallback(() => {
    setLoading(true)
    axios
      .get<Array<User>>('https://jsonplaceholder.typicode.com/users')
      .then((res) => {
        setUsers(res.data)
      })
      .catch(() => {
        showMessage({ message: 'ユーザーの取得に失敗しました', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  return { getUsers, loading, users }
}
