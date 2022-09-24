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
import { CommonLayout } from '@/components/templates/CommonLayout'
import { MainLayout } from '@/components/templates/MainLayout'

export const Router: FC = () => (
  <Routes>
    <Route path="/" element={<Home />} />
    {/** /以下のパスに共通のレイアウトを適用 */}
    <Route path="/" element={<CommonLayout />}>
      <Route path="about" element={<About />} />
      <Route path="help" element={<Help />} />
      <Route path="signup" element={<SignUp />} />
      <Route path="signin" element={<SignIn />} />
      <Route path="*" element={<Page404 />} />
    </Route>
    {/** /user/以下のパスに共通のレイアウトを適用 */}
    <Route path="user" element={<MainLayout />}>
      <Route index element={<UserHome />} />
      <Route path="home" element={<UserHome />} />
      <Route path="edit" element={<UserEdit />} />
    </Route>
  </Routes>
)
