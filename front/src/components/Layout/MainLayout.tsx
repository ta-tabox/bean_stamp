import type { FC } from 'react'
import { memo } from 'react'
import { Outlet } from 'react-router-dom'

import { AsideContent } from '@/components/Layout/Aside/AsideContent'
import { BottomNav } from '@/components/Layout/Nav/BottomNav'
import { SideNav } from '@/components/Layout/Nav/SideNav'
import { TopNav } from '@/components/Layout/Nav/TopNav'

export const MainLayout: FC = memo(() => (
  <div className="max-w-screen-2xl lg:mx-auto">
    <div className="flex flex-col lg:flex-row">
      {/* ナビコンテンツ */}
      <nav className="">
        {/* モバイルトップナビ */}
        <div className="lg:hidden">
          <TopNav />
        </div>
        {/* モバイルボトムナビ */}
        <div className="lg:hidden">
          <BottomNav />
        </div>
        {/* デスクトップサイドナビ */}
        <div className="h-full w-28 hidden lg:block">
          <SideNav />
        </div>
      </nav>
      {/* メインコンテンツ */}
      <main className="lg:w-9/12">
        <div className="container mx-auto my-14 lg:my-0">
          <Outlet /> {/* Outletがページ毎に置き換わる */}
        </div>
      </main>
      {/* サイドコンテンツ */}
      <aside className="w-3/12 hidden lg:block">
        <AsideContent />
      </aside>
    </div>
  </div>
))
