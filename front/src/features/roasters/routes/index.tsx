import type { FC } from 'react'
import { Navigate, Route, Routes } from 'react-router-dom'

import { MainLayout } from '@/components/Layout/MainLayout'
import { Roaster } from '@/features/roasters/components/pages/Roaster'
import { RoasterCancel } from '@/features/roasters/components/pages/RoasterCancel'
import { RoasterEdit } from '@/features/roasters/components/pages/RoasterEdit'
import { RoasterHome } from '@/features/roasters/components/pages/RoasterHome'
import { RoasterNew } from '@/features/roasters/components/pages/RoasterNew'
import { UserFollowing } from '@/features/users/components/pages/UserFollowing'
import { RequireForBelongingToRoaster } from '@/router/RequireForBelongingToRoaster'
import { RequireForNotBelongingToRoaster } from '@/router/RequireForNotBelongingToRoaster'

export const RoastersRoutes: FC = () => (
  <Routes>
    <Route element={<MainLayout />}>
      {/* ロースター未所属を要求 */}
      <Route element={<RequireForNotBelongingToRoaster redirectPath="/roasters/home" />}>
        <Route path="new" element={<RoasterNew />} />
      </Route>
      {/* ロースター所属を要求 */}
      <Route element={<RequireForBelongingToRoaster />}>
        <Route index element={<RoasterHome />} />
        <Route path="home" element={<RoasterHome />} />
        <Route path="edit" element={<RoasterEdit />} />
        <Route path="cancel" element={<RoasterCancel />} />
      </Route>
      {/* ロースター所属未所属を問わない */}
      <Route path=":id" element={<Roaster />} />
      <Route path=":id/following" element={<UserFollowing />} />
      <Route path="*" element={<Navigate to="/roasters/home" replace />} />
    </Route>
  </Routes>
)
