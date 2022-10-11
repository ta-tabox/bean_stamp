import type { FC } from 'react'
import { useEffect } from 'react'
import { BrowserRouter } from 'react-router-dom'

import { IconsSvg } from '@/components/atoms/icon/IconsSvg'
import { ToastMessage } from '@/components/organisms/layout/ToastMessage'
import { useGetCurrentUser } from '@/hooks/useGetCurrentUser'
import { Router } from '@/router/Router'

const App: FC = () => {
  const { getCurrentUser } = useGetCurrentUser()

  // ログイン中にリロードした際にStateにログイン情報を格納する
  useEffect(() => {
    getCurrentUser()
  }, [])

  return (
    <BrowserRouter>
      <IconsSvg />
      <ToastMessage />
      <Router />
    </BrowserRouter>
  )
}

export default App
