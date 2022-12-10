import type { FC } from 'react'
import { Navigate, Route, Routes } from 'react-router-dom'

import { MainLayout } from '@/components/Layout/MainLayout'
import { User } from '@/features/users/components/pages/User'
import { UserCancel } from '@/features/users/components/pages/UserCancel'
import { UserEdit } from '@/features/users/components/pages/UserEdit'
import { UserFollowing } from '@/features/users/components/pages/UserFollowing'
import { UserHome } from '@/features/users/components/pages/UserHome'
import { UserPassword } from '@/features/users/components/pages/UserPassword'
import { RequireNotIsRoaster } from '@/router/RequireNotIsRoaster'

export const UsersRoutes: FC = () => (
  <Routes>
    <Route element={<MainLayout />}>
      <Route element={<RequireNotIsRoaster />}>
        <Route index element={<UserHome />} />
        <Route path="home" element={<UserHome />} />
        <Route path="edit" element={<UserEdit />} />
        <Route path="password" element={<UserPassword />} />
        <Route path="cancel" element={<UserCancel />} />
      </Route>
      <Route path=":id" element={<User />} />
      <Route path=":id/following" element={<UserFollowing />} />
      <Route path="*" element={<Navigate to="." />} />
    </Route>
  </Routes>
)
