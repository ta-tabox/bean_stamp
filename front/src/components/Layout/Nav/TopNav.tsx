import type { FC } from 'react'
import { memo } from 'react'

import { TopButton, TopNavRoasterToggleButton } from '@/components/Elements/Button'

export const TopNav: FC = memo(() => (
  <nav className="h-14 fixed top-0 inset-x-0 z-40 border-b border-gray-200 bg-gray-100">
    <div className="h-full flex items-center justify-between">
      <div className="pl-4">
        <TopButton />
      </div>
      <div className="mr-4">
        <TopNavRoasterToggleButton />
      </div>
    </div>
  </nav>
))
