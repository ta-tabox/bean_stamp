import type { FC } from 'react'
import { Navigate, Route, Routes } from 'react-router-dom'

import { MainLayout } from '@/components/Layout/MainLayout'
import { RoasterHome } from '@/features/roasters/components/pages/RoasterHome'
import { User } from '@/features/users/components/pages/User'
import { UserCancel } from '@/features/users/components/pages/UserCancel'
import { UserEdit } from '@/features/users/components/pages/UserEdit'
import { UserFollowing } from '@/features/users/components/pages/UserFollowing'
import { RequireForBelongingToRoaster } from '@/router/RequireForBelongingToRoaster'
import { RequireForNotBelongingToRoaster } from '@/router/RequireForNotBelongingToRoaster'

export const RoastersRoutes: FC = () => (
  <Routes>
    <Route element={<MainLayout />}>
      {/* ロースター未所属を要求 */}
      <Route element={<RequireForNotBelongingToRoaster redirectPath="home" />}>
        <Route path="new" element={<RoasterHome />} />
      </Route>
      {/* ロースター所属を要求 */}
      <Route element={<RequireForBelongingToRoaster />}>
        <Route index element={<RoasterHome />} />
        <Route path="home" element={<RoasterHome />} />
        <Route path="edit" element={<UserEdit />} />
        <Route path="cancel" element={<UserCancel />} />
      </Route>
      {/* ロースター所属未所属を問わない */}
      <Route path=":id" element={<User />} />
      <Route path=":id/following" element={<UserFollowing />} />
      <Route path="*" element={<Navigate to="." />} />
    </Route>
  </Routes>
)
