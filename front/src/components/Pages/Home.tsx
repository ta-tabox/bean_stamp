import type { FC } from 'react'
import { memo } from 'react'
import { Navigate } from 'react-router-dom'

import { Head } from '@/components/Head'
import { useAuth } from '@/features/auth'

export const Home: FC = memo(() => {
  const { isSignedIn } = useAuth()

  // ルートパスアクセス時にログイン済みならリダイレクト
  if (isSignedIn) {
    return <Navigate to="/user/home" replace />
  }

  return (
    <>
      <Head />
      <h1>TOPページ</h1>
    </>
  )
})
