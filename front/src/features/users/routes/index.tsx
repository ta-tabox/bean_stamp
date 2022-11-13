import type { FC } from 'react'
import { Navigate, Route, Routes } from 'react-router-dom'

import { MainLayout } from '@/components/Layout/MainLayout'
import { User } from '@/features/users/components/pages/User'
import { UserCancel } from '@/features/users/components/pages/UserCancel'
import { UserEdit } from '@/features/users/components/pages/UserEdit'
import { UserHome } from '@/features/users/components/pages/UserHome'
import { UserManagement } from '@/features/users/components/pages/UserManagement'
import { UserPassword } from '@/features/users/components/pages/UserPassword'

export const UsersRoutes: FC = () => (
  <Routes>
    <Route element={<MainLayout />}>
      <Route index element={<UserHome />} />
      <Route path="home" element={<UserHome />} />
      <Route path="edit" element={<UserEdit />} />
      <Route path="password" element={<UserPassword />} />
      <Route path="management" element={<UserManagement />} />
      <Route path="cancel" element={<UserCancel />} />
      <Route path=":id" element={<User />} />
      <Route path="*" element={<Navigate to="." />} />
    </Route>
  </Routes>
)
