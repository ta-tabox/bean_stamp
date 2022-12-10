import type { FC } from 'react'
import { Navigate, Route, Routes } from 'react-router-dom'

import { MainLayout } from '@/components/Layout/MainLayout'
import { Roaster } from '@/features/roasters/components/pages/Roaster'
import { RoasterHome } from '@/features/roasters/components/pages/RoasterHome'
import { UserCancel } from '@/features/users/components/pages/UserCancel'
import { UserEdit } from '@/features/users/components/pages/UserEdit'
import { UserFollowing } from '@/features/users/components/pages/UserFollowing'
import { RequireForBelongingToRoaster } from '@/router/RequireForBelongingToRoaster'
import { RequireForNotBelongingToRoaster } from '@/router/RequireForNotBelongingToRoaster'

export const RoastersRoutes: FC = () => (
  <Routes>
    <Route element={<MainLayout />}>
      {/* ロースター未所属を要求 */}
      <Route element={<RequireForNotBelongingToRoaster redirectPath="/roasters/home" />}>
        <Route path="new" element={<UserCancel />} />
      </Route>
      {/* ロースター所属を要求 */}
      <Route element={<RequireForBelongingToRoaster />}>
        <Route index element={<RoasterHome />} />
        <Route path="home" element={<RoasterHome />} />
        <Route path="edit" element={<UserEdit />} />
        <Route path="cancel" element={<UserCancel />} />
      </Route>
      {/* ロースター所属未所属を問わない */}
      <Route path=":id" element={<Roaster />} />
      <Route path=":id/following" element={<UserFollowing />} />
      <Route path="*" element={<Navigate to="/roasters/home" replace />} />
    </Route>
  </Routes>
)
