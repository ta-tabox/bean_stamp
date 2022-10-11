import type { FC } from 'react'
import { Route, Routes } from 'react-router-dom'

import { About } from '@/components/pages/common/About'
import { Help } from '@/components/pages/common/Help'
import { Home } from '@/components/pages/common/Home'
import { Page404 } from '@/components/pages/common/Page404'
import { SignIn } from '@/components/pages/common/SignIn'
import { SignUp } from '@/components/pages/common/SignUp'
import { UserEdit } from '@/components/pages/users/UserEdit'
import { UserHome } from '@/components/pages/users/UserHome'
import { UserManagement } from '@/components/pages/users/UserManagement'
import { CommonLayout } from '@/components/templates/CommonLayout'
import { MainLayout } from '@/components/templates/MainLayout'
import { ProtectedRoute } from '@/router/ProtectedRoute'
import { RequireSignedOutRoute } from '@/router/RequireSignedOutRoute'

export const Router: FC = () => (
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
      </Route>
    </Route>
  </Routes>
)
