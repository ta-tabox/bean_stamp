import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import axios from 'axios'

import 'react-toastify/dist/ReactToastify.css'

import { useLoginUser } from '@/hooks/useLoginUser'
import { useMessage } from '@/hooks/useMessage'
import type { User } from '@/types/api/user'

export const useAuth = () => {
  const navigate = useNavigate()
  const { showMessage } = useMessage()
  const [loading, setLoading] = useState(false)
  const { setLoginUser } = useLoginUser()

  const login = useCallback((id: string) => {
    setLoading(true)
    axios
      .get<User>(`https://jsonplaceholder.typicode.com/users/${id}`)
      .then((res) => {
        if (res.data) {
          const isAdmin = res.data.id === 10 // idが10の時にisAdminをtrueに設定する
          setLoginUser({ ...res.data, isAdmin }) // res.dataを展開してisAdminフラグを追加する
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
  return { login, loading, setLoginUser }
}
