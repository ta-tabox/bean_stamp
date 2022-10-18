import type { FC } from 'react'
import { useEffect } from 'react'
import { Route, Routes } from 'react-router-dom'

import { CommonLayout } from '@/components/Layout'
import { About, Help, Home, Page404 } from '@/components/Pages'
import { useGetCurrentUser } from '@/features/auth'
import { AuthRoutes } from '@/features/auth/routes'
import { UsersRoutes } from '@/features/users/routes'
import { ProtectedRoute } from '@/router/ProtectedRoute'
import { RequireSignedOutRoute } from '@/router/RequireSignedOutRoute'

export const AppRouter: FC = () => {
  // TODO 適切な場所に移動する
  const { getCurrentUser } = useGetCurrentUser()

  // ログイン中にリロードした際にStateにログイン情報を格納する
  useEffect(() => {
    getCurrentUser()
  }, [])

  return (
    <Routes>
      {/** /以下のパスに共通のレイアウトを適用 */}
      <Route path="/" element={<Home />} />
      <Route element={<CommonLayout />}>
        <Route path="about" element={<About />} />
        <Route path="help" element={<Help />} />
      </Route>
      {/* 未ログインを要求 */}
      <Route element={<RequireSignedOutRoute />}>
        <Route path="auth/*" element={<AuthRoutes />} />
      </Route>
      {/* ログイン済みを要求 */}
      <Route element={<ProtectedRoute />}>
        <Route path="user/*" element={<UsersRoutes />} />
      </Route>
      <Route element={<CommonLayout />}>
        <Route path="*" element={<Page404 />} />
      </Route>
    </Routes>
  )
}
