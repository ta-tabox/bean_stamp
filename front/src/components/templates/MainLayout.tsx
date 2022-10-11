import type { FC } from 'react'
import { memo } from 'react'
import { Outlet } from 'react-router-dom'

import { Header } from '@/components/organisms/layout/Header'

export const MainLayout: FC = memo(() => (
  <>
    <Header />
    <div className="pt-14">
      <p>MainLayout</p>
      <Outlet /> {/* Outletがページ毎に置き換わる */}
    </div>
  </>
))
