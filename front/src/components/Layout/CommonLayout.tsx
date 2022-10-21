import type { FC } from 'react'
import { memo } from 'react'
import { Outlet } from 'react-router-dom'

import { Header } from '@/components/Layout/Header'

export const CommonLayout: FC = memo(() => (
  <>
    <Header />
    <div className="pt-14">
      <Outlet /> {/* Outletがページ毎に置き換わる */}
    </div>
  </>
))
