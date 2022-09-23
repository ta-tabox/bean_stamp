import type { FC } from 'react'
import { memo } from 'react'

import { TopButton } from '@/components/atoms/button/TopButton'
import { StaticNavLink } from '@/components/atoms/link/StaticNavLink'

export const Header: FC = memo(() => (
  <section className="h-14 border-t border-b z-50 text-black border-gray-200 bg-gray-100 opacity-80 inset-x-0">
    <div className="h-full flex items-center justify-between">
      <TopButton />
      {/* 切り替えアイコン */}
      <nav className="pr-2 md:pr-12 h-full">
        <ul className="flex h-full">
          <li>
            <StaticNavLink to="/">HOME</StaticNavLink>
          </li>
          <li>
            <StaticNavLink to="/about">ABOUT</StaticNavLink>
          </li>
          <li>
            <StaticNavLink to="/help">HELP</StaticNavLink>
          </li>
        </ul>
      </nav>
    </div>
  </section>
))
