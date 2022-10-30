import type { FC } from 'react'
import { memo } from 'react'
import { Outlet } from 'react-router-dom'

import { Header } from '@/components/Layout/Header'

export const HeaderLayout: FC = memo(() => (
  <>
    <Header />
    <Outlet /> {/* Outletがページ毎に置き換わる */}
  </>
))
