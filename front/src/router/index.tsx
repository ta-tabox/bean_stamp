import type { FC } from 'react'
import { useEffect } from 'react'
import { Route, Routes } from 'react-router-dom'

import { CommonLayout, MainLayout } from '@/components/Layout'
import { About, Help, Home, Page404 } from '@/components/Pages'
import { useLoadUser } from '@/features/auth'
import { AuthRoutes } from '@/features/auth/routes'
import { BeansRoutes } from '@/features/beans/routes'
import { OffersRoutes } from '@/features/offers/routes'
import { RoastersRoutes } from '@/features/roasters/routes'
import { UsersRoutes } from '@/features/users/routes'
import { ProtectedRoute } from '@/router/ProtectedRoute'
import { RequireSignedOutRoute } from '@/router/RequireSignedOutRoute'

export const AppRouter: FC = () => {
  const { loadUser } = useLoadUser()
  // サインイン中にリロードした際にStateにサインイン情報を格納する
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
      {/* 未サインインを要求 */}
      <Route element={<RequireSignedOutRoute />}>
        <Route path="auth/*" element={<AuthRoutes />} />
      </Route>
      {/* サインイン済みを要求 */}
      <Route element={<ProtectedRoute />}>
        <Route element={<MainLayout />}>
          <Route path="users/*" element={<UsersRoutes />} />
          <Route path="roasters/*" element={<RoastersRoutes />} />
          <Route path="beans/*" element={<BeansRoutes />} />
          <Route path="offers/*" element={<OffersRoutes />} />
        </Route>
      </Route>
      <Route path="*" element={<Page404 />} />
    </Routes>
  )
}
