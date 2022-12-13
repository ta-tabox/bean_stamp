import type { FC } from 'react'
import { useEffect } from 'react'
import { Route, Routes } from 'react-router-dom'

import { CommonLayout, MainLayout } from '@/components/Layout'
import { About, Help, Home, Page404 } from '@/components/Pages'
import { useLoadUser } from '@/features/auth'
import { AuthRoutes } from '@/features/auth/routes'
import { RoastersRoutes } from '@/features/roasters/routes'
import { UsersRoutes } from '@/features/users/routes'
import { ProtectedRoute } from '@/router/ProtectedRoute'
import { RequireSignedOutRoute } from '@/router/RequireSignedOutRoute'

export const AppRouter: FC = () => {
  const { loadUser } = useLoadUser()
  // ログイン中にリロードした際にStateにログイン情報を格納する
  useEffect(() => {
    void loadUser()
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
        <Route element={<MainLayout />}>
          <Route path="users/*" element={<UsersRoutes />} />
          <Route path="roasters/*" element={<RoastersRoutes />} />
        </Route>
      </Route>
      <Route path="*" element={<Page404 />} />
    </Routes>
  )
}
