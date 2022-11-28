import type { FC } from 'react'
import { useNavigate } from 'react-router-dom'

import { AxiosError } from 'axios'

import { SecondaryButton } from '@/components/Elements/Button'
import { useAuth } from '@/features/auth/hooks/useAuth'
import { useMessage } from '@/hooks/useMessage'

export const GuestSignInButton: FC = () => {
  const { signIn } = useAuth()
  const { showMessage } = useMessage()
  const navigate = useNavigate()

  const handleClickGuestLogin = async () => {
    const params = {
      email: 'guest@example.com',
      password: 'password',
    }
    try {
      await signIn(params)
      showMessage({ message: 'ゲストユーザーでログインしました', type: 'success' })
      navigate('/users/home')
    } catch (error) {
      if (error instanceof AxiosError) {
        showMessage({ message: 'ゲストログインに失敗しました', type: 'error' })
      }
    }
  }
  return <SecondaryButton onClick={handleClickGuestLogin}>ゲストログイン</SecondaryButton>
}
