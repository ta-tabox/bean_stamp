import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import axios from 'axios'

import type { User } from '@/types/api/user'

export const useAuth = () => {
  const navigate = useNavigate()

  const [loading, setLoading] = useState(false)

  const login = useCallback((id: string) => {
    setLoading(true)
    axios
      .get<User>(`https://jsonplaceholder.typicode.com/users/${id}`)
      .then((res) => {
        if (res.data) {
          navigate('/user/home')
        } else {
          alert('ユーザーが見つかりません')
        }
      })
      .catch(() => {
        alert('ログインできませんでした')
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])
  return { login, loading }
}
