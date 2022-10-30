import type { FC } from 'react'
import { memo } from 'react'
import { Outlet } from 'react-router-dom'

import { Header } from '@/components/Layout/Header'

export const MainLayout: FC = memo(() => (
  <>
    <Header />
    <p>MainLayout</p>
    <Outlet /> {/* Outletがページ毎に置き換わる */}
  </>
))
