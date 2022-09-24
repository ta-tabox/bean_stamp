import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import axios from 'axios'
import 'react-toastify/dist/ReactToastify.css'

import { useMessage } from '@/hooks/useMessage'
import type { User } from '@/types/api/user'

export const useAuth = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()

  const [loading, setLoading] = useState(false)

  const login = useCallback((id: string) => {
    setLoading(true)
    axios
      .get<User>(`https://jsonplaceholder.typicode.com/users/${id}`)
      .then((res) => {
        if (res.data) {
          showMessage({ message: 'ログインしました', type: 'success' })
          navigate('/user/home')
        } else {
          showMessage({ message: 'ユーザーが見つかりません', type: 'error' })
        }
      })
      .catch(() => {
        showMessage({ message: 'ログインできませんでした', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])
  return { login, loading }
}
