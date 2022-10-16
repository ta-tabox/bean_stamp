import type { FC } from 'react'
import { useEffect } from 'react'
import { Route, Routes } from 'react-router-dom'

import { About } from '@/components/pages/common/About'
import { Help } from '@/components/pages/common/Help'
import { Home } from '@/components/pages/common/Home'
import { Page404 } from '@/components/pages/common/Page404'
import { PasswordReset } from '@/components/pages/common/PasswordReset'
import { SignIn } from '@/components/pages/common/SignIn'
import { SignUp } from '@/components/pages/common/SignUp'
import { UserCancel } from '@/components/pages/users/UserCancel'
import { UserEdit } from '@/components/pages/users/UserEdit'
import { UserHome } from '@/components/pages/users/UserHome'
import { UserManagement } from '@/components/pages/users/UserManagement'
import { CommonLayout } from '@/components/templates/CommonLayout'
import { MainLayout } from '@/components/templates/MainLayout'
import { useGetCurrentUser } from '@/hooks/useGetCurrentUser'
import { ProtectedRoute } from '@/router/ProtectedRoute'
import { RequireSignedOutRoute } from '@/router/RequireSignedOutRoute'

export const Router: FC = () => {
  // TODO 適切な場所に移動する
  const { getCurrentUser } = useGetCurrentUser()

  // ログイン中にリロードした際にStateにログイン情報を格納する
  useEffect(() => {
    getCurrentUser()
  }, [])

  return (
    <Routes>
      {/** /以下のパスに共通のレイアウトを適用 */}
      <Route path="/" element={<CommonLayout />}>
        <Route path="/" element={<Home />} />
        <Route path="about" element={<About />} />
        <Route path="help" element={<Help />} />
        {/* 未ログインを要求 */}
        <Route element={<RequireSignedOutRoute />}>
          <Route path="signup" element={<SignUp />} />
          <Route path="signin" element={<SignIn />} />
          <Route path="password_reset" element={<PasswordReset />} />
        </Route>
        <Route path="*" element={<Page404 />} />
      </Route>
      {/** /user/以下のパスに共通のレイアウトを適用 */}
      <Route element={<ProtectedRoute />}>
        <Route path="user" element={<MainLayout />}>
          <Route index element={<UserHome />} />
          <Route path="home" element={<UserHome />} />
          <Route path="edit" element={<UserEdit />} />
          <Route path="management" element={<UserManagement />} />
          <Route path="cancel" element={<UserCancel />} />
        </Route>
      </Route>
    </Routes>
  )
}
